{
  packages,
  ...
}:
{
  homeManagerImports = [
    (
      { config, ... }:
      {
        programs.claude-code = {
          enable = true;
          package = packages.claude-code;
          skillsDir = ./skills;
          settings = {
            env = {
              CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1";
              CLAUDE_CODE_ENABLE_TELEMETRY = "1";
              CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
              CLAUDE_CODE_HIDE_ACCOUNT_INFO = "1";
              CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL = "1";
              DISABLE_AUTOUPDATER = "1";
              DISABLE_INSTALLATION_CHECKS = "1";
              OTEL_EXPORTER_OTLP_ENDPOINT = "http://localhost:4317";
              OTEL_EXPORTER_OTLP_PROTOCOL = "grpc";
              OTEL_LOGS_EXPORTER = "otlp";
              OTEL_METRICS_EXPORTER = "otlp";
            };
            hooks = {
              Notification = [
                {
                  hooks = [
                    {
                      command = "cc-voice-reporter hook-receiver";
                      type = "command";
                    }
                  ];
                }
              ];
              PermissionRequest = [
                {
                  hooks = [
                    {
                      command = "cc-voice-reporter hook-receiver";
                      type = "command";
                    }
                  ];
                }
              ];
              SessionStart = [
                {
                  hooks = [
                    {
                      command = "cc-voice-reporter hook-receiver";
                      type = "command";
                    }
                  ];
                }
              ];
            };
            permissions = {
              additionalDirectories = [
                "/tmp/"
                "${config.home.homeDirectory}/Library/Caches/ms-playwright"
                "${config.home.homeDirectory}/.claude/projects"
                "${config.home.homeDirectory}/.claude/skills"
                "${config.home.homeDirectory}/.claude/teams"
                "${config.home.homeDirectory}/.claude/tasks"
              ];
              allow = [
                "Bash(actionlint:*)"
                "Bash(aws cloudwatch list-metrics:*)"
                "Bash(aws configure get:*)"
                "Bash(aws pi get-resource-metrics:*)"
                "Bash(aws rds describe-db-instances:*)"
                "Bash(aws rds describe-db-clusters:*)"
                "Bash(aws s3 ls:*)"
                "Bash(aws s3api head-bucket:*)"
                "Bash(aws sts get-caller-identity:*)"
                "Bash(basename:*)"
                "Bash(brew list:*)"
                "Bash(brew info:*)"
                "Bash(cat:*)"
                "Bash(chmod +x:*)"
                "Bash(claude --version)"
                "Bash(claude mcp get:*)"
                "Bash(claude mcp list:*)"
                "Bash(comm:*)"
                "Bash(command:*)"
                "Bash(convert:*)"
                "Bash(cp:*)"
                "Bash(defaults read:*)"
                "Bash(devenv test)"
                "Bash(diff:*)"
                "Bash(done:*)"
                "Bash(do echo:*)"
                "Bash(do sed:*)"
                "Bash(do sleep:*)"
                "Bash(echo:*)"
                "Bash(find:*)"
                "Bash(file:*)"
                "Bash(for:*)"
                "Bash(gemini:*)"
                "Bash(gh cache list:*)"
                "Bash(gh issue list:*)"
                "Bash(gh issue view:*)"
                "Bash(gh label list:*)"
                "Bash(gh pr checks:*)"
                "Bash(gh pr diff:*)"
                "Bash(gh pr list:*)"
                "Bash(gh pr view:*)"
                "Bash(gh release list:*)"
                "Bash(gh release view:*)"
                "Bash(gh repo view:*)"
                "Bash(gh run download:*)"
                "Bash(gh run list:*)"
                "Bash(gh run view:*)"
                "Bash(gh run watch:*)"
                "Bash(gh search:*)"
                "Bash(git add:*)"
                "Bash(git apply:*)"
                "Bash(git check-ignore:*)"
                "Bash(git commit:*)"
                "Bash(git diff:*)"
                "Bash(git fetch:*)"
                "Bash(git ls-files:*)"
                "Bash(git ls-remote:*)"
                "Bash(git ls-tree:*)"
                "Bash(git log:*)"
                "Bash(git merge-base:*)"
                "Bash(git mv:*)"
                "Bash(git rebase --continue)"
                "Bash(git remote get-url:*)"
                "Bash(git remote prune:*)"
                "Bash(git reset --soft:*)"
                "Bash(git rev-parse:*)"
                "Bash(git show:*)"
                "Bash(git submodule status:*)"
                "Bash(git status:*)"
                "Bash(git symbolic-ref:*)"
                "Bash(git --version)"
                "Bash(grep:*)"
                "Bash(head:*)"
                "Bash(iconv:*)"
                "Bash(jq:*)"
                "Bash(ls:*)"
                "Bash(lsof:*)"
                "Bash(magick:*)"
                "Bash(make)"
                "Bash(mas search:*)"
                "Bash(mkdir:*)"
                "Bash(mv:*)"
                "Bash(nix flake check)"
                "Bash(nix flake metadata:*)"
                "Bash(nix flake show)"
                "Bash(nix log:*)"
                "Bash(nkf:*)"
                "Bash(node --version)"
                "Bash(npm audit fix)"
                "Bash(npm ci)"
                "Bash(npm config get:*)"
                "Bash(npm info:*)"
                "Bash(npm install)"
                "Bash(npm list:*)"
                "Bash(npm ls:*)"
                "Bash(npm outdated:*)"
                "Bash(npm pack:*)"
                "Bash(npm rebuild:*)"
                "Bash(npm run)"
                "Bash(npm search:*)"
                "Bash(npm test)"
                "Bash(npm uninstall:*)"
                "Bash(npm update)"
                "Bash(npm view:*)"
                "Bash(npm whoami:*)"
                "Bash(npm --version)"
                "Bash(npx @playwright/cli --help)"
                "Bash(npx @playwright/cli click:*)"
                "Bash(npx @playwright/cli close:*)"
                "Bash(npx @playwright/cli fill:*)"
                "Bash(npx @playwright/cli press-key:*)"
                "Bash(npx @playwright/cli press:*)"
                "Bash(npx @playwright/cli run-code --help)"
                "Bash(npx @playwright/cli screenshot:*)"
                "Bash(npx @playwright/cli snapshot:*)"
                "Bash(npx @playwright/cli type:*)"
                "Bash(npx depcruise:*)"
                "Bash(npx electron-builder:*)"
                "Bash(npx electron-rebuild:*)"
                "Bash(npx eslint:*)"
                "Bash(npx jest:*)"
                "Bash(npx prisma generate:*)"
                "Bash(npx tsc:*)"
                "Bash(npx vite build:*)"
                "Bash(npx vitest run:*)"
                "Bash(od:*)"
                "Bash(ollama list:*)"
                "Bash(ollama ps:*)"
                "Bash(ollama pull:*)"
                "Bash(otool:*)"
                "Bash(pgrep:*)"
                "Bash(playwright-cli check:*)"
                "Bash(playwright-cli click:*)"
                "Bash(playwright-cli close:*)"
                "Bash(playwright-cli dialog-accept:*)"
                "Bash(playwright-cli dialog-dismiss:*)"
                "Bash(playwright-cli fill:*)"
                "Bash(playwright-cli hover:*)"
                "Bash(playwright-cli keydown:*)"
                "Bash(playwright-cli keyup:*)"
                "Bash(playwright-cli mousemove:*)"
                "Bash(playwright-cli mousewheel:*)"
                "Bash(playwright-cli press:*)"
                "Bash(playwright-cli press-key:*)"
                "Bash(playwright-cli reload:*)"
                "Bash(playwright-cli resize:*)"
                "Bash(playwright-cli screenshot:*)"
                "Bash(playwright-cli select:*)"
                "Bash(playwright-cli snapshot:*)"
                "Bash(playwright-cli tab-close:*)"
                "Bash(playwright-cli tab-list:*)"
                "Bash(playwright-cli tab-select:*)"
                "Bash(playwright-cli type:*)"
                "Bash(playwright-cli uncheck:*)"
                "Bash(playwright-cli upload:*)"
                "Bash(playwright-cli video-start:*)"
                "Bash(playwright-cli video-stop:*)"
                "Bash(playwright-cli --help)"
                "Bash(playwright-cli --version)"
                "Bash(prek:*)"
                "Bash(pre-commit run:*)"
                "Bash(printf:*)"
                "Bash(ps:*)"
                "Bash(pwd:*)"
                "Bash(python --version)"
                "Bash(rg:*)"
                "Bash(sed:*)"
                "Bash(shellcheck:*)"
                "Bash(sleep:*)"
                "Bash(sort:*)"
                "Bash(strings:*)"
                "Bash(swift build:*)"
                "Bash(swift test:*)"
                "Bash(swift --version:*)"
                "Bash(tail:*)"
                "Bash(tar:*)"
                "Bash(test:*)"
                "Bash(touch:*)"
                "Bash(tree:*)"
                "Bash(true)"
                "Bash(type:*)"
                "Bash(uniq:*)"
                "Bash(unzip:*)"
                "Bash(uv pip list:*)"
                "Bash(uv remove:*)"
                "Bash(uv run ruff:*)"
                "Bash(uv sync)"
                "Bash(uv --version)"
                "Bash(wc:*)"
                "Bash(which:*)"
                "Bash(xargs cat:*)"
                "Bash(xargs npx eslint:*)"
                "Bash(xargs sed:*)"
                "Bash(xcodebuild:*)"
                "Bash(xxd:*)"
                "Bash(yarn)"
                "Bash(yarn eslint:*)"
                "Bash(yarn jest:*)"
                "Bash(yarn prisma generate:*)"
                "Bash(yarn tsc:*)"
                "Bash(yarn vitest run:*)"
                "Bash(yarn --version)"
                "WebFetch(domain:api.anthropic.com)"
                "WebFetch(domain:api.github.com)"
                "WebFetch(domain:arxiv.org)"
                "WebFetch(domain:awslabs.github.io)"
                "WebFetch(domain:blog.langchain.com)"
                "WebFetch(domain:cybersecuritynews.com)"
                "WebFetch(domain:deepwiki.com)"
                "WebFetch(domain:developers.notion.com)"
                "WebFetch(domain:docs.anthropic.com)"
                "WebFetch(domain:docs.github.com)"
                "WebFetch(domain:docs.google.com)"
                "WebFetch(domain:docs.npmjs.com)"
                "WebFetch(domain:docs.slack.dev)"
                "WebFetch(domain:gist.github.com)"
                "WebFetch(domain:gist.githubusercontent.com)"
                "WebFetch(domain:github.com)"
                "WebFetch(domain:global.moneyforward-dev.jp)"
                "WebFetch(domain:itunes.apple.com)"
                "WebFetch(domain:localhost)"
                "WebFetch(domain:mizunashi-mana.github.io)"
                "WebFetch(domain:moneyforward-dev.jp)"
                "WebFetch(domain:mynixos.com)"
                "WebFetch(domain:note.com)"
                "WebFetch(domain:ollama.com)"
                "WebFetch(domain:openai.com)"
                "WebFetch(domain:pypi.org)"
                "WebFetch(domain:raw.githubusercontent.com)"
                "WebFetch(domain:research.google)"
                "WebFetch(domain:socket.dev)"
                "WebFetch(domain:stackoverflow.com)"
                "WebFetch(domain:storybook.js.org)"
                "WebFetch(domain:support.anthropic.com)"
                "WebFetch(domain:support.claude.com)"
                "WebFetch(domain:tessl.io)"
                "WebFetch(domain:typescript-eslint.io)"
                "WebFetch(domain:vitest.dev)"
                "WebFetch(domain:www.anthropic.com)"
                "WebFetch(domain:www.figma.com)"
                "WebFetch(domain:www.notion.so)"
                "WebFetch(domain:www.npmjs.com)"
                "WebFetch(domain:www.youtube.com)"
                "WebFetch(domain:zenn.dev)"
                "WebFetch(domain:zod.dev)"
                "WebSearch"
                "mcp__chrome-devtools__click"
                "mcp__chrome-devtools__close_page"
                "mcp__chrome-devtools__fill"
                "mcp__chrome-devtools__fill_form"
                "mcp__chrome-devtools__get_console_message"
                "mcp__chrome-devtools__get_network_request"
                "mcp__chrome-devtools__hover"
                "mcp__chrome-devtools__list_console_messages"
                "mcp__chrome-devtools__list_network_requests"
                "mcp__chrome-devtools__list_pages"
                "mcp__chrome-devtools__press_key"
                "mcp__chrome-devtools__select_page"
                "mcp__chrome-devtools__take_snapshot"
                "mcp__chrome-devtools__take_screenshot"
                "mcp__chrome-devtools__wait_for"
                "mcp__claude_ai_Figma__get_figjam"
                "mcp__claude_ai_Figma__get_metadata"
                "mcp__claude_ai_Figma__get_screenshot"
                "mcp__claude_ai_Linear__get_issue"
                "mcp__claude_ai_Linear__get_team"
                "mcp__claude_ai_Linear__list_comments"
                "mcp__claude_ai_Linear__list_issues"
                "mcp__claude_ai_Linear__list_issue_labels"
                "mcp__claude_ai_Notion__notion-fetch"
                "mcp__claude_ai_Notion__notion-search"
                "mcp__claude_ai_Sentry__analyze_issue_with_seer"
                "mcp__claude_ai_Sentry__find_organizations"
                "mcp__claude_ai_Sentry__get_issue_details"
                "mcp__claude_ai_Sentry__search_events"
                "mcp__claude_ai_Sentry__search_issue_events"
                "mcp__claude_ai_Sentry__search_issues"
                "mcp__claude_ai_Slack__slack_read_thread"
                "mcp__claude_ai_Slack__slack_search_public_and_private"
                "mcp__eslint__lint-files"
                "mcp__github__get_commit"
                "mcp__github__get_file_contents"
                "mcp__github__get_latest_release"
                "mcp__github__get_me"
                "mcp__github__get_pull_request"
                "mcp__github__get_pull_request_comments"
                "mcp__github__get_pull_request_diff"
                "mcp__github__get_pull_request_file_contents"
                "mcp__github__get_pull_request_files"
                "mcp__github__issue_read"
                "mcp__github__list_branches"
                "mcp__github__list_commits"
                "mcp__github__list_issues"
                "mcp__github__list_pull_requests"
                "mcp__github__list_tags"
                "mcp__github__pull_request_read"
                "mcp__github__search_code"
                "mcp__github__search_issues"
                "mcp__github__search_pull_requests"
                "mcp__github__search_repositories"
                "mcp__github__search_users"
                "mcp__ide__getDiagnostics"
                "mcp__playwright__browser_click"
                "mcp__playwright__browser_close"
                "mcp__playwright__browser_console_messages"
                "mcp__playwright__browser_file_upload"
                "mcp__playwright__browser_fill_form"
                "mcp__playwright__browser_handle_dialog"
                "mcp__playwright__browser_hover"
                "mcp__playwright__browser_install"
                "mcp__playwright__browser_network_requests"
                "mcp__playwright__browser_press_key"
                "mcp__playwright__browser_resize"
                "mcp__playwright__browser_select_option"
                "mcp__playwright__browser_snapshot"
                "mcp__playwright__browser_tabs"
                "mcp__playwright__browser_take_screenshot"
                "mcp__playwright__browser_type"
                "mcp__playwright__browser_wait_for"
                "mcp__serena__find_file"
                "mcp__serena__find_referencing_symbols"
                "mcp__serena__find_symbol"
                "mcp__serena__get_symbols_overview"
                "mcp__serena__list_dir"
                "mcp__serena__list_memories"
                "mcp__serena__onboarding"
                "mcp__serena__prepare_for_new_conversation"
                "mcp__serena__read_file"
                "mcp__serena__read_memory"
                "mcp__serena__think_about_collected_information"
                "mcp__serena__think_about_task_adherence"
                "mcp__serena__think_about_whether_you_are_done"
                "mcp__html-artifacts-preview__create_page"
                "mcp__html-artifacts-preview__update_page"
                "mcp__html-artifacts-preview__destroy_page"
                "mcp__html-artifacts-preview__get_pages"
                "mcp__html-artifacts-preview__get_page"
                "mcp__html-artifacts-preview__add_scripts"
                "mcp__html-artifacts-preview__add_stylesheets"
              ];
              defaultMode = "acceptEdits";
              deny = [
                "Bash(git -C:*)"
              ];
            };
            statusLine = {
              command = "~/.claude/statusline.sh";
              type = "command";
            };
          };
        };

        home.file = {
          ".claude/statusline.sh" = {
            source = ./statusline.sh;
            executable = true;
          };
        };

        programs.agent-skills = {
          targets.claude.enable = true;
        };
      }
    )
  ];
}
