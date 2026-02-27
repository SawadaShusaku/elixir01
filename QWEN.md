# Elixir01 Project Context

## Project Overview

This is an **Elixir/Phoenix** development workspace containing two Phoenix web applications:

| Project | Description | Database |
|---------|-------------|----------|
| `hello/` | Phoenix 1.8 web application with LiveView | PostgreSQL |
| `myapp/` | Phoenix 1.8 web application with LiveView | SQLite |
| `simple.exs` | Simple standalone Elixir script | N/A |

Both Phoenix applications follow the standard Phoenix 1.8 structure with LiveView, Tailwind CSS, and esbuild for asset management.

## Directory Structure

```
elixir01/
├── simple.exs          # Standalone Elixir script
├── LICENSE             # Apache License 2.0
├── hello/              # Phoenix app (PostgreSQL)
│   ├── config/         # Environment configs
│   ├── lib/
│   │   ├── hello/      # Business logic contexts
│   │   └── hello_web/  # Web layer (controllers, LiveViews, components)
│   ├── priv/           # Static assets, migrations
│   ├── test/           # Test files
│   └── assets/         # CSS/JS source files
└── myapp/              # Phoenix app (SQLite)
    └── ...             # Same structure as hello/
```

## Building and Running

### Prerequisites

- Elixir ~> 1.15
- Erlang/OTP
- PostgreSQL (for `hello` app)
- SQLite (for `myapp` app, built-in)

### Common Commands

```bash
# Navigate to project directory
cd hello    # or cd myapp

# Install dependencies and setup database
mix setup

# Start Phoenix server
mix phx.server

# Start Phoenix server in IEx
iex -S mix phx.server

# Run tests
mix test

# Run tests in specific file
mix test test/path/to_test.exs

# Run only failed tests
mix test --failed

# Format code
mix format

# Precommit checks (compile, format, test)
mix precommit
```

### Access Points

- `hello` app: http://localhost:4000
- `myapp` app: http://localhost:4000 (when running separately)

## Development Conventions

### Code Style

- **Formatter**: Uses `Phoenix.LiveView.HTMLFormatter` plugin
- **Formatted files**: `*.{heex,ex,exs}` in root, `config/`, `lib/`, `test/`, and migration directories
- **License**: Apache License 2.0

### Phoenix 1.8 Guidelines

#### LiveView Templates

- Always begin LiveView templates with `<Layouts.app flash={@flash} ...>` wrapper
- Use `<.link navigate={href}>` for navigation (not deprecated `live_redirect`)
- Use `<.form for={@form}>` with `to_form/2` assigned in LiveView
- Use `<.input>` component from `core_components.ex` for form inputs
- Use `<.icon name="hero-x-mark" />` for icons (Heroicons via `<.icon>` component)

#### CSS/JS

- Tailwind CSS v4 syntax in `app.css`:
  ```css
  @import "tailwindcss" source(none);
  @source "../css";
  @source "../js";
  @source "../../lib/hello_web";
  ```
- Write custom Tailwind components (no daisyUI)
- Only `app.js` and `app.css` bundles are supported
- No inline `<script>` tags in templates

#### Elixir Guidelines

- Use `Enum.at/2` for list index access (no `list[i]` syntax)
- Bind results of block expressions (`if`, `case`, `cond`):
  ```elixir
  # VALID
  socket =
    if connected?(socket) do
      assign(socket, :val, val)
    end
  ```
- Never nest multiple modules in the same file
- Use `Task.async_stream/3` for concurrent enumeration with back-pressure
- Predicate functions end with `?` (e.g., `valid?/0`)

#### Ecto Guidelines

- Preload associations when accessing in templates
- Use `Ecto.Changeset.get_field/2` to access changeset fields
- Fields set programmatically (e.g., `user_id`) must not be in `cast/2`

#### Testing

- Use `Phoenix.LiveViewTest` module
- Use `LazyHTML` for HTML assertions (included in deps)
- Use `render_submit/2` and `render_change/2` for form tests
- Test for element presence with `has_element?/2`, not raw text
- Add unique DOM IDs to elements for test selectors

### HTTP Client

- Use `:req` (`Req`) library for HTTP requests
- Avoid `:httpoison`, `:tesla`, `:httpc`

### Mix Aliases

```elixir
mix setup       # deps.get, ecto.setup, assets.setup, assets.build
mix ecto.reset  # ecto.drop, ecto.setup
mix precommit   # compile --warning-as-errors, deps.unlock --unused, format, test
```

## Key Files

| File | Purpose |
|------|---------|
| `mix.exs` | Project dependencies and configuration |
| `config/config.exs` | Base configuration |
| `config/runtime.exs` | Runtime configuration (environment variables) |
| `lib/*_web.ex` | Web interface definitions (controller, html, live_view macros) |
| `lib/*_web/router.ex` | Route definitions |
| `lib/*_web/components/` | LiveView components and UI elements |
| `assets/css/app.css` | Tailwind CSS entry point |
| `assets/js/app.js` | JavaScript entry point |

## AGENTS.md

Both `hello/AGENTS.md` and `myapp/AGENTS.md` contain detailed development guidelines for AI assistants, including:
- Phoenix 1.8 specific patterns
- LiveView best practices
- Form handling guidelines
- Testing conventions
- UI/UX design principles
