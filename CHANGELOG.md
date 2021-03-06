# Changelog
All notable changes to this project will be documented in this file.

## Unreleased
### Changed
- (semantics, refactorigns): `Jaina::Parser::Expression::Operator` namespace has been renamed to
  `Jaina::Parser::Expression::Unit` namespace;

## [0.7.0] - 2019-06-28
### Added
- Support for cyrillic symbols in tokens;

## [0.6.0] - 2019-06-28
### Added
- New token symbols (`-`, `=`, `>`, `<`): you can use these in your operands and operators;

### Fixed
- Expression inheritance (internal state of the child of child isnt copied but should);

## [0.5.0] - 2019-06-27
### Added
- An ability to redefine existing expressions (`Jaina.redefine(expression_klass)`);

## [0.4.1] - 2019-06-24
### Fixed
- Fxied `NOT` operator (`#evaluate` fails on incorrect `context` varibale name);

## [0.4.0] - 2019-06-24
### Added
- Support for operand arguments and operator arguments;

## [0.3.0] - 2019-06-21
### Added
- Support for initial context: `Jaina.evaluate(program, **initial_context)`

## [0.2.0] - 2019-06-21
### Added
- `#evaluate(context)` implementation for all core operators (`AND`, `OR`, `NOT`);

## [0.1.0] - 2018-06-19
- Release :)
