# Contributing to backend-forge

Thanks for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Run tests: `bash test.sh`

## Making Changes

1. Create a feature branch: `git checkout -b feat/your-feature`
2. Make your changes
3. Run tests: `bash test.sh`
4. Commit with a clear message
5. Push and open a Pull Request

## Code Style

- Shell scripts: follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Markdown: no trailing whitespace, one sentence per line
- JSON: 2-space indent
- All user-facing text in English

## What to Contribute

- Bug fixes
- New provider alternatives (add to `alternatives.md`)
- Test improvements
- Documentation fixes
- Schema validation improvements

## What NOT to Contribute

- New commands without discussion (open an issue first)
- Changes to the secret resolution mechanism
- Anything that requires runtime dependencies beyond bash + python3

## Reporting Issues

Use [GitHub Issues](https://github.com/SkyWalker2506/ccplugin-backend-forge/issues). Include:
- What you expected
- What happened
- Steps to reproduce

## License

By contributing, you agree that your contributions will be licensed under MIT.
