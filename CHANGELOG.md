# Changelog
All notable changes to this project will be documented in this file.

1.2.0 - 2015-08-13
------------------

### Added
- Support for paginated responses (robholland)

1.1.0 - 2015-02-19
------------------

### Added
- New submit method for submitting units without loading them

### Fixed
- Error where units are not loaded when submitted via the load method
- Out-dated Gemfile.lock

1.0.0 - 2015-02-17
------------------

### Added
- Support for official Fleet API (no longer reading/writing directly from/to etcd)
- New get_unit_state and get_unit_file methods

### Fixed
- Proper encoding of @ symbol when submitting unit templates

0.9.0 - 2015-01-14
------------------

### Added
- Support for listing all loaded units

0.8.0 - 2014-11-07
------------------

### Added
- Support for mutl-value options in unit file
- Enforcement of Fleet service naming conventions

0.6.1 - 2014-09-20
------------------

### Fixed
- Default to async operations to address performance issues

0.6.0 - 2014-09-05
------------------

### Added
- Compatibility for Fleet 0.6.x (not backward compatible with older versions of Fleet)

0.5.3 - 2014-08-26
------------------

### Added
- Support for listing machines in CoreOS cluster

### Fixed
- Will follow etcd redirects when communicating with non-master endpoints

0.5.2 - 2014-08-20
------------------

Initial release
