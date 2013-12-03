require 'tilt'
require 'json'
require 'curb'
require 'csv'

require 'active_model_serializers'
require 'active_support/concern'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object' # gives us to_json
require 'active_support/inflector'

require "iraq_unrest/version"
require "iraq_unrest/config"
require "iraq_unrest/concerns/validatable"
require "iraq_unrest/concerns/serializable"
require "iraq_unrest/serializers"
require "iraq_unrest/format"
require "iraq_unrest/google_doc"
require "iraq_unrest/data_set"
require "iraq_unrest/iraq_government_casualty_figure"
require "iraq_unrest/iraqi_casualties_comparison"

IraqUnrest::Config.configure do |config|
  config.doc_id = "0Aia6y6NymliRdEZESktBSWVqNWM1dkZOSGNIVmtFZEE"
  config.timeout = 30
  config.disclaimer = <<-EOS
##################################################
# NOTE: This file was generated by a free software
# program [ https://github.com/bds/iraq_unrest ]
# which retrieved publicly shared data
# provided by Agence France-Presse.
#
# Figures are provided by Iraqi officials
# on a monthly basis, and have been compiled by
# Agence France-Presse at:
#
# http://u.afp.com/JSL
#
# They are based on data released by the Iraqi
# ministries of health, interior and defence.
# If you have any questions, please contact:
#
# AFP's Baghdad Bureau
# https://twitter.com/prashantrao
##################################################
EOS
end

module IraqUnrest
end