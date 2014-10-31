  module API
    module V1
      class Base < Grape::API
        mount API::V1::Projects
        mount API::V1::Staff

        add_swagger_documentation(
          api_version: 'v1',
          hide_documentation_path: true,
          hide_format: true,
          base_path: 'api'
        )
      end
    end
  end
