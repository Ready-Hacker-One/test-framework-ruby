require 'active_record'
require 'active_support/core_ext/object/json'
require 'colorize'
require 'json'
require 'minitest'
require 'ostruct'
require 'require_all'
require 'rest-client'
require 'securerandom'
require 'net/http'
require 'uri'

require_all File.dirname(__FILE__) + '/../../config'
require_all File.dirname(__FILE__) + '/../../app'

$test_config = QaTestConfig.config

RestClient.log = $stdout