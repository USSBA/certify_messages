# Changelog
All notable changes to this project will be documented in this file.

## [1.5.0] - 2018-10-09
### shared-services-sprint-55
  - Added
    - HUB-1643: Added api_key to configuration in anticipation of AWS API Gateway
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
