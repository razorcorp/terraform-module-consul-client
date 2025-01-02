# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.2.0] - 2025-01-02
### Added
- Script logging to console and log file

### Fixed
- The incorrect resource path. Correct path is `/opt/resources/consul`
- APT and DPKG lock issue between scripts
- GPG keyring override issue

## [v0.1.0] - 2025-01-02
### Changed
- Restructured resource directory on host to avoid module collision. Resource will be placed in `/opt/consul/` directory on host

## [v0.0.2] - 2025-01-01
### Fixed
- CHANGELOG.md version update logic in the Jenkins pipeline

## [v0.0.1] 2025-01-01
### Added
- Consul client configuration
- Initial repo setup

[Unreleased]:  https://github.com/praveenprem/terraform-module-consul-client/compare/v0.2.0...develop
[v0.2.0]:  https://github.com/praveenprem/terraform-module-consul-client/compare/v0.1.0...v0.2.0
[v0.1.0]:  https://github.com/praveenprem/terraform-module-consul-client/compare/v0.0.2...v0.1.0
[v0.0.2]:  https://github.com/praveenprem/terraform-module-consul-client/compare/v0.0.1...v0.0.2
[v0.0.1]:  https://github.com/praveenprem/terraform-module-consul-client/compare/b9e72b26...v0.0.1
    