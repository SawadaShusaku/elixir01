# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Elixir + Phoenix web application designed for learning Elixir concepts. The application provides interactive learning experiences through:
- A main learning page with basic Elixir concepts (Pattern Matching, Pipe Operator, Immutability)
- A LiveView version with real-time interactive exercises
- Syntax courses covering Elixir fundamentals in Japanese

## Key Components

### Core Learning Logic
- `lib/myapp/learning.ex`: Contains the main learning logic and tutorial content
  - Defines lessons with examples and descriptions
  - Provides pipeline evaluation functionality for interactive exercises
  - Includes syntax course materials with step-by-step lessons

### Web Interface
- `lib/myapp_web/controllers/page_html/learn.html.heex`: Main learning page with static content
- `lib/myapp_web/live/learn_live.ex` and `lib/myapp_web/live/learn_live.html.heex`: LiveView version with real-time interactive exercises

### Architecture
- Uses Phoenix framework (v1.8.1) with LiveView for real-time updates
- SQLite database (via ecto_sqlite3)
- Tailwind CSS for styling
- Phoenix LiveReload for development

## Development Commands

### Setup
```bash
mix setup
```

### Running the Server
```bash
mix phx.server
# Or in IEx:
iex -S mix phx.server
```

### Testing
```bash
# Run all tests
mix test

# Run specific test file
mix test test/myapp/learning_test.exs

# Run tests with coverage
mix coveralls.html
```

### Asset Management
```bash
# Build assets
mix assets.build

# Build assets for production
mix assets.deploy
```

## Learning Extension Points

To extend the learning content:
1. Add lessons to `Myapp.Learning.lessons/0` in `lib/myapp/learning.ex`
2. Add syntax lessons to `Myapp.Learning.syntax_lessons/0` in `lib/myapp/learning.ex`
3. Add sample results to `Myapp.Learning.sample_results/0` in `lib/myapp/learning.ex`
4. Update templates in `lib/myapp_web/controllers/page_html/learn.html.heex` or `lib/myapp_web/live/learn_live.html.heex`
5. Add tests to `test/myapp/learning_test.exs`

## URLs
- Main learning page: http://localhost:4000/learn
- LiveView learning page: http://localhost:4000/learn/live
- Syntax courses: http://localhost:4000/learn/syntax