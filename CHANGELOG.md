# Changelog
All notable changes to this project will be documented in this file.

## [2.2.1] - 2019-02-28
### shared-services-sprint-63
### Changed
  - HUB-1812
    - Updates documentation
  - Prepped code base for open source

## [2.2.0] - 2018-12-21
### shared-services-sprint-58
  - Added
    - HUB-1688: [v2/3] added `author_uuid` to collection of permitted keys

## [2.1.0] - 2018-12-07
### shared-services-sprint-57
  - Added
    - HUB-1718: added support for message-api v2
  - Changed
    - HUB-1648: corrected the use of id/uuid in the conversation paths

## [2.0.0] - 2018-11-21
### shared-services-sprint-56
  - Added
    - HUB-1700: Updated for use with Notification API v3

## [1.5.0] - 2018-11-09
### shared-services-sprint-55
  - Added
    - HUB-1643: Added api_key to configuration in anticipation of AWS API Gateway
  - Changed
    - HUB-1676
      - Changed test to new pattern using VCR

## [1.4.0] - 2018-09-14
### shared-services-sprint-51
  - Added
    - HUB-1575: Added api_key to configuration in anticipation of AWS API Gateway

## [1.3.0] - 2018-08-17
### shared-services-sprint-49
  - Added
    - HUB-1399: Added endpoint to acquire message counts for a given recipient across a list of application ids.

## [1.2.0] - 2017-11-10
### shared-services-sprint-29
  - Added
    - HUB-923 support `conversation_type`

    - HUB-920:
      - Added custom configuration of `excon_timeout` and makes it available to be configured by gem user.
      - Sets Excon connection values for `connect_timeout`, `read_timeout` and `write_timeout` to equal value of `excon_timeout`
      - Added logger functionality to the gem, refer to README for more details about configuration.


## [1.1.0] - 2017-10-27
### shared-services-sprint-28
  - Added
    - HUB-908
        - Added support for `priority_read_receipt` property for messages.  Refer to [Messages API](https://github.com/USSBA/message-api) for more details about this feature.

## [1.0.1] - 2017-09-28
### shared-services-sprint-27

  No Changes

### shared-services-sprint-26
### Added
  - Added this CHANGELOG.md

## [1.0.0] - 2017-08-31
### shared-services-sprint-24
