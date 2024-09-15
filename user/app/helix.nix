{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "horizon-dark";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor = {
        auto-save = true;
        default-line-ending = "lf";
        insert-final-newline = true; # Ensure a newline at the end of file
        line-number = "absolute"; # Show absolute line numbers
        cursorline = true; # Highlight the line where the cursor is located
        cursorcolumn = true; # Highlight the column where the cursor is located
        scrolloff = 3; # Keep at least 3 lines above and below the cursor when scrolling
        scroll-lines = 5; # Number of lines to scroll per scroll wheel step
        gutters = [
          "diagnostics"
          "spacer"
          "line-numbers"
          "spacer"
          "diff"
        ]; # Gutters configuration
        auto-completion = true; # Enable automatic pop-up of auto-completion
        auto-format = true; # Enable automatic formatting on save
        idle-timeout = 250; # Time in milliseconds since last keypress before idle timers trigger
        completion-timeout = 250; # Time in milliseconds after typing a word character before completions are shown
        preview-completion-insert = true; # Apply completion item instantly when selected
        completion-trigger-len = 2; # The min-length of word under cursor to trigger auto-completion
        completion-replace = false; # Make completions always replace the entire word
        auto-info = true; # Whether to display info boxes
        true-color = false; # Override automatic detection of terminal truecolor support
        undercurl = false; # Override automatic detection of terminal undercurl support
        # rulers = []; # No rulers set by default
        bufferline = "never"; # Do not display bufferline
        color-modes = false; # Do not color the mode indicator
        text-width = 80; # Maximum line length
        # workspace-lsp-roots = []; # No specific LSP roots set
        popup-border = "none"; # No border around popups
        indent-heuristic = "hybrid"; # Use hybrid indent heuristic
        jump-label-alphabet = "abcdefghijklmnopqrstuvwxyz"; # Alphabet for jump labels

        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        lsp = {
          enable = true; # Enable LSP integration
          display-messages = true; # Do not display LSP progress messages
          auto-signature-help = true; # Enable automatic popup of signature help
          display-inlay-hints = true; # Do not display inlay hints
          display-signature-help-docs = true; # Display docs under signature help popup
          snippets = true; # Enable snippet completions
          goto-reference-include-declaration = true; # Include declaration in the goto references popup
        };

      };
    };

    languages = {
      language-server.pylsp.config.pylsp = {
        "plugins.pyls_mypy.enabled" = true;
        "plugins.pyls_mypy.live_mode" = true;
      };

      language-server.deno-lsp = {
        command = "deno";
        args = [ "lsp" ];
      };
      language-server.deno-lsp.config.deno = {
        enable = true;
      };
      grammar = [
        {
          name = "haskell";
          source.git = "https://github.com/tree-sitter/tree-sitter-haskell";
          source.rev = "e29c59236283198d93740a796c50d1394bccbef5";
        }
      ];
      language = with pkgs; [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "haskell";
          scope = "source.haskell";
          injection-regex = "hs|haskell";
          file-types = [
            "hs"
            "hs-boot"
            "hsc"
          ];
          roots = [
            "Setup.hs"
            "stack.yaml"
            "cabal.project"
          ];
          comment-token = "--";
          block-comment-tokens.start = "{-";
          block-comment-tokens.end = "-}";
          language-servers = [ "haskell-language-server" ];
          indent.tab-width = 2;
          indent.unit = "  ";

        }
        {
          name = "typescript";
          auto-format = true;
          language-id = "typescript";
          scope = "source.ts";
          injection-regex = "^(ts|typescript)$";
          file-types = [ "ts" ];
          shebangs = [ "deno" ];
          roots = [
            "deno.json"
            "deno.jsonc"
            "package.json"
          ];
          language-servers = [ "deno-lsp" ];
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "${python312Packages.black}/bin/black";
          language-servers = [ "pylsp" ];
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${rustfmt}/bin/rustfmt";
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "javascript";
          auto-format = true;
          formatter.command = "${nodePackages.prettier}/bin/prettier";
          formatter.args = [ "--write" ];
          language-servers = [ "typescript-language-server" ];

        }
        {
          name = "html";
          auto-format = true;
          formatter = [ "prettier" ];
        }
        {
          name = "css";
          auto-format = true;
          formatter.command = "${nodePackages.prettier}/bin/prettier";
          formatter.args = [ "--write" ];
        }
        {
          name = "json";
          auto-format = true;
          formatter.command = "${nodePackages.prettier}/bin/prettier";
          formatter.args = [ "--write" ];
        }
        {
          name = "yaml";
          auto-format = true;
          formatter.command = "${nodePackages.prettier}/bin/prettier";
          formatter.args = [ "--write" ];
        }
        {
          name = "markdown";
          auto-format = true;
          formatter.command = "${nodePackages.prettier}/bin/prettier";
          formatter.args = [ "--write" ];
        }
      ];
    };

  };
}
