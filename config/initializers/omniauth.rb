# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
# frozen_string_literal: true

# require 'omniauth/strategies/microsoft_graph_auth'

# TODO circumvent the need for 
# ENV's, 'cause this does not work unless we set the ENV's atm!!
#
# Rails.application.config.middleware.use OmniAuth::Builder do
#   # provider :developer unless Rails.env.production?
#   provider :microsoft_graph_auth,
#            ENV.fetch('AZURE_APP_ID'),
#            ENV.fetch('AZURE_APP_SECRET'),
#            scope: ENV.fetch('AZURE_SCOPES')
# end

