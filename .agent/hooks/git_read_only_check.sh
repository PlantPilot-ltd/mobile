#!/usr/bin/env bash
# Tool-agnostic check for .agent/rules/git.md: agents may only READ with git/gh.
# Usage: git_read_only_check.sh "<shell command>"   (or the command on stdin)
# Exit 0 — allowed; exit 1 — writes git state, needs the user (reason on stdout).
cmd="${1-$(cat)}"

deny() { echo "Blocked by .agent/rules/git.md (git is read-only for agents): $1"; exit 1; }

# Arguments after the subcommand that are not options.
positional() { local a; for a in "$@"; do [[ $a != -* ]] && echo "$a"; done; }

check_git() { # $@ = args after "git"
  while [[ $# -gt 0 && $1 == -* ]]; do        # global options
    case $1 in -C|-c|--git-dir|--work-tree|--namespace) shift ;; esac
    shift
  done
  local sub=$1; shift || true
  case $sub in
    ""|status|log|show|diff|blame|annotate|grep|shortlog|whatchanged|describe|\
    ls-files|ls-tree|ls-remote|rev-parse|rev-list|cat-file|merge-base|name-rev|\
    diff-tree|diff-index|diff-files|for-each-ref|show-ref|show-branch|count-objects|\
    check-ignore|check-attr|var|version|help|range-diff|cherry) return 0 ;;
    reflog) [[ -z $1 || $1 == show || $1 == -* ]] && return 0 ;;
    branch|tag)
      [[ $sub == tag && "$*" =~ (^|[[:space:]])(-a|-s|-u|--annotate|--sign)([[:space:]]|$) ]] && deny "git tag $*"
      [[ "$*" =~ (^|[[:space:]])(-d|-D|-m|-M|-c|-C|-f|--delete|--move|--copy|--force|--set-upstream-to|-u|--unset-upstream|--edit-description)([[:space:]]|$) ]] && deny "git $sub $*"
      [[ "$*" =~ (^|[[:space:]])(-l|--list|--contains|--no-contains|--merged|--no-merged|--points-at)([[:space:]]|$) ]] && return 0
      [[ -z $(positional "$@") ]] && return 0 ;;
    remote) [[ -z $1 || $1 == -v || $1 == --verbose || $1 == show || $1 == get-url ]] && return 0 ;;
    config) [[ "$*" =~ (^|[[:space:]])(--get|--get-all|--get-regexp|--list|-l|--show-origin|--show-scope)([[:space:]]|$) ]] && return 0 ;;
    stash) [[ $1 == list || $1 == show ]] && return 0 ;;
    submodule) [[ -z $1 || $1 == status || $1 == summary ]] && return 0 ;;
    worktree) [[ $1 == list ]] && return 0 ;;
    notes) [[ -z $1 || $1 == list || $1 == show ]] && return 0 ;;
  esac
  deny "git $sub $*"
}

check_gh() { # $@ = args after "gh"
  local group=$1 action=$2
  case $group in
    api) [[ "$*" =~ (-X|--method)[[:space:]=]*(POST|PUT|PATCH|DELETE|post|put|patch|delete) || "$*" =~ (^|[[:space:]])(-f|-F|--field|--raw-field|--input)([[:space:]]|$) ]] && deny "gh $*"; return 0 ;;
    status|search|browse|help|version|--version|auth) [[ $group == auth && $action != status ]] && deny "gh $*"; return 0 ;;
  esac
  case $action in view|list|status|diff|checks|"") return 0 ;; esac
  deny "gh $*"
}

# Split into simple commands on ; & | && || newlines and subshell parens, then scan words.
while IFS= read -r segment; do
  read -ra words <<< "$segment"
  for i in "${!words[@]}"; do
    w=${words[$i]##*/}                                   # /usr/bin/git -> git
    case $w in
      git) check_git "${words[@]:i+1}"; break ;;
      gh)  check_gh  "${words[@]:i+1}"; break ;;
    esac
  done
done < <(printf '%s\n' "$cmd" | tr ';&|()`' '\n\n\n\n\n\n')
exit 0
