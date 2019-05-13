{
  _, path, inputTypeName, fileName
} = require '../../func_helper'

{
  GraphQLInputObjectType
  GraphQLNonNull
  GraphQLObjectType
  GraphQLBoolean
  GraphQLString
} = require 'graphql'

InputType = new GraphQLInputObjectType {
  name: inputTypeName __filename
  description: "Input for #{fileName __filename}"
  fields: -> {
    env: {
      type: new GraphQLNonNull GraphQLString
      description: """
        **Example:**
        
        "acm-inter-staging"
      """
    }
    profile: {
      type: GraphQLString
      description: """
        **Example:**
        
        "vn_operation_authcenter_biz_customer_session"
      """
    }
    input: {
      type: GraphQLString
      description: """
        GCS bucket input path

        **Example:**

        "gs://acm-dp-ocp-tmn-vn-qa-source-archive/vn_operation_authcenter/biz_customer_session"
      """
    }
    output: {
      type: GraphQLString
      description: """
        GCS bucket output path

        **Example:**

        "gs://acm-dp-ocp-tmn-vn-qa-source-archive-clean/
        vn_operation_authcenter/biz_customer_session"
      """
    }
    bqPath: {
      type: GraphQLString
      description: """
        BigQuery path

        **Example:**

        "acm-inter-staging:source_local_DF_testing.vn_operation_authcenter_biz_customer_session",
      """
    }
    bqWriteMode: {
      type: require('/app/types/enums/bq_write_mode')
    }
    scheduler: {
      type: require('/app/types/enums/scheduler')
    }
    runner: {
      type: require('/app/types/enums/runner')
    }
    directLoad: {
      type: GraphQLBoolean
      defaultValue: false
    }
    jobTriggerEndPoint: {
      type: GraphQLString
      description: """
        **Example:**

        "view/acm-inter-staging/job/vn_operation_authcenter/job/biz_customer_session"
      """
    }
    trigger: {
      type: GraphQLString
      description: """
        **Example:**

        "gs://acm-dp-ocp-tmn-vn-qa-source-archive/vn_operation_authcenter/
        biz_customer_session/2019/03/biz_customer_session_20190301_082145.sha256"
      """
    }
  }
}

Type = require "/app/types/job"
self = {
  name: 'ddd'
  description: """
    *Trigger* a Jenkins job
    
    in our DataPlatform system. The job must be early created and allow for the

    **\"Trigger Builds Remotely\"**
  """
  type: Type
  args: {
    input: {
      type: InputType
    }
  }
  resolve: ->
    console.log "-1-"
}

module.exports = self