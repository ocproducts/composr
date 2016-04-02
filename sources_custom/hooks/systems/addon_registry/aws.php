<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    aws
 */

/**
 * Hook class.
 */
class Hook_addon_registry_aws
{
    /**
     * Get a list of file permissions to set
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Development';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Chris Graham';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array('Amazon');
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Apache license';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Features to improve integration with Amazon Web Services. At this time this only includes a handler to remove bounce messages detected within the Amazon SES e-mail framework. The whole AWS SDK for PHP is bundled though.

[title]Amazon SES[/title]

Amazon SES allows very high volume bulk e-mailing, while conventional web hosts will put low limits on how many e-mails you can send. SES is by far the best priced bulk e-mailing provider.

To configure SES we recommend you specifically set the newsletter configuration options so that only newsletters send via your Amazon SES SMTP server. This has a number of advantages:
1) You can make use of the SES sandbox to test your infrastructure separate to your other e-mailing activities
2) SES is subject to an approval step, so you can\'t switch over to it immediately anyway
3) SES has particular policies that you must comply with, and if they judge you as non-compliant you don\'t want all your e-mail to stop
4) Usually your host-based e-mail is free, while SES is paid -- so it makes sense to only use SES for when you really do need the high-volume stuff
5) SES is more likely to be on spam blacklists, so it makes sense to isolate its use to bulk e-mail only
6) Putting your bulk e-mail through a separate queue will avoid clogging up the delivery of your other e-mails, which may be more time-sensitive

It is not optional that you have to remove bounced addresses from your newsletter: Amazon may penalise you if you don\'t. You therefore need to listen to the bounces that Amazon picks up.
You need to:
1) Set up an Amazon SNS topic
2) Set up an HTTP subscription to the topic to http://baseurl/data_custom/amazon_sns_topic_handler.php
3) Set up SNS to publish to the topic
';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array();
    }

    /**
     * Get a mapping of dependency types
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array('PHP5.5', 'curl'),
            'recommends' => array(),
            'conflicts_with' => array()
        );
    }

    /**
     * Explicitly say which icon should be used
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/_generic_admin/tool.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/aws.php',
            'data_custom/amazon_sns_topic_handler.php',
            'sources_custom/aws.php',

            'sources_custom/aws/Aws/Acm/AcmClient.php',
            'sources_custom/aws/Aws/Acm/Exception/AcmException.php',
            'sources_custom/aws/Aws/Api/AbstractModel.php',
            'sources_custom/aws/Aws/Api/ApiProvider.php',
            'sources_custom/aws/Aws/Api/DateTimeResult.php',
            'sources_custom/aws/Aws/Api/DocModel.php',
            'sources_custom/aws/Aws/Api/ErrorParser/JsonParserTrait.php',
            'sources_custom/aws/Aws/Api/ErrorParser/JsonRpcErrorParser.php',
            'sources_custom/aws/Aws/Api/ErrorParser/RestJsonErrorParser.php',
            'sources_custom/aws/Aws/Api/ErrorParser/XmlErrorParser.php',
            'sources_custom/aws/Aws/Api/ListShape.php',
            'sources_custom/aws/Aws/Api/MapShape.php',
            'sources_custom/aws/Aws/Api/Operation.php',
            'sources_custom/aws/Aws/Api/Parser/AbstractParser.php',
            'sources_custom/aws/Aws/Api/Parser/AbstractRestParser.php',
            'sources_custom/aws/Aws/Api/Parser/Crc32ValidatingParser.php',
            'sources_custom/aws/Aws/Api/Parser/Exception/ParserException.php',
            'sources_custom/aws/Aws/Api/Parser/JsonParser.php',
            'sources_custom/aws/Aws/Api/Parser/JsonRpcParser.php',
            'sources_custom/aws/Aws/Api/Parser/PayloadParserTrait.php',
            'sources_custom/aws/Aws/Api/Parser/QueryParser.php',
            'sources_custom/aws/Aws/Api/Parser/RestJsonParser.php',
            'sources_custom/aws/Aws/Api/Parser/RestXmlParser.php',
            'sources_custom/aws/Aws/Api/Parser/XmlParser.php',
            'sources_custom/aws/Aws/Api/Serializer/Ec2ParamBuilder.php',
            'sources_custom/aws/Aws/Api/Serializer/JsonBody.php',
            'sources_custom/aws/Aws/Api/Serializer/JsonRpcSerializer.php',
            'sources_custom/aws/Aws/Api/Serializer/QueryParamBuilder.php',
            'sources_custom/aws/Aws/Api/Serializer/QuerySerializer.php',
            'sources_custom/aws/Aws/Api/Serializer/RestJsonSerializer.php',
            'sources_custom/aws/Aws/Api/Serializer/RestSerializer.php',
            'sources_custom/aws/Aws/Api/Serializer/RestXmlSerializer.php',
            'sources_custom/aws/Aws/Api/Serializer/XmlBody.php',
            'sources_custom/aws/Aws/Api/Service.php',
            'sources_custom/aws/Aws/Api/Shape.php',
            'sources_custom/aws/Aws/Api/ShapeMap.php',
            'sources_custom/aws/Aws/Api/StructureShape.php',
            'sources_custom/aws/Aws/Api/TimestampShape.php',
            'sources_custom/aws/Aws/Api/Validator.php',
            'sources_custom/aws/Aws/ApiGateway/ApiGatewayClient.php',
            'sources_custom/aws/Aws/ApiGateway/Exception/ApiGatewayException.php',
            'sources_custom/aws/Aws/AutoScaling/AutoScalingClient.php',
            'sources_custom/aws/Aws/AutoScaling/Exception/AutoScalingException.php',
            'sources_custom/aws/Aws/AwsClient.php',
            'sources_custom/aws/Aws/AwsClientInterface.php',
            'sources_custom/aws/Aws/AwsClientTrait.php',
            'sources_custom/aws/Aws/CacheInterface.php',
            'sources_custom/aws/Aws/ClientResolver.php',
            'sources_custom/aws/Aws/CloudFormation/CloudFormationClient.php',
            'sources_custom/aws/Aws/CloudFormation/Exception/CloudFormationException.php',
            'sources_custom/aws/Aws/CloudFront/CloudFrontClient.php',
            'sources_custom/aws/Aws/CloudFront/CookieSigner.php',
            'sources_custom/aws/Aws/CloudFront/Exception/CloudFrontException.php',
            'sources_custom/aws/Aws/CloudFront/Signer.php',
            'sources_custom/aws/Aws/CloudFront/UrlSigner.php',
            'sources_custom/aws/Aws/CloudHsm/CloudHsmClient.php',
            'sources_custom/aws/Aws/CloudHsm/Exception/CloudHsmException.php',
            'sources_custom/aws/Aws/CloudSearch/CloudSearchClient.php',
            'sources_custom/aws/Aws/CloudSearch/Exception/CloudSearchException.php',
            'sources_custom/aws/Aws/CloudSearchDomain/CloudSearchDomainClient.php',
            'sources_custom/aws/Aws/CloudSearchDomain/Exception/CloudSearchDomainException.php',
            'sources_custom/aws/Aws/CloudTrail/CloudTrailClient.php',
            'sources_custom/aws/Aws/CloudTrail/Exception/CloudTrailException.php',
            'sources_custom/aws/Aws/CloudTrail/LogFileIterator.php',
            'sources_custom/aws/Aws/CloudTrail/LogFileReader.php',
            'sources_custom/aws/Aws/CloudTrail/LogRecordIterator.php',
            'sources_custom/aws/Aws/CloudWatch/CloudWatchClient.php',
            'sources_custom/aws/Aws/CloudWatch/Exception/CloudWatchException.php',
            'sources_custom/aws/Aws/CloudWatchEvents/CloudWatchEventsClient.php',
            'sources_custom/aws/Aws/CloudWatchEvents/Exception/CloudWatchEventsException.php',
            'sources_custom/aws/Aws/CloudWatchLogs/CloudWatchLogsClient.php',
            'sources_custom/aws/Aws/CloudWatchLogs/Exception/CloudWatchLogsException.php',
            'sources_custom/aws/Aws/CodeCommit/CodeCommitClient.php',
            'sources_custom/aws/Aws/CodeCommit/Exception/CodeCommitException.php',
            'sources_custom/aws/Aws/CodeDeploy/CodeDeployClient.php',
            'sources_custom/aws/Aws/CodeDeploy/Exception/CodeDeployException.php',
            'sources_custom/aws/Aws/CodePipeline/CodePipelineClient.php',
            'sources_custom/aws/Aws/CodePipeline/Exception/CodePipelineException.php',
            'sources_custom/aws/Aws/CognitoIdentity/CognitoIdentityClient.php',
            'sources_custom/aws/Aws/CognitoIdentity/CognitoIdentityProvider.php',
            'sources_custom/aws/Aws/CognitoIdentity/Exception/CognitoIdentityException.php',
            'sources_custom/aws/Aws/CognitoSync/CognitoSyncClient.php',
            'sources_custom/aws/Aws/CognitoSync/Exception/CognitoSyncException.php',
            'sources_custom/aws/Aws/Command.php',
            'sources_custom/aws/Aws/CommandInterface.php',
            'sources_custom/aws/Aws/CommandPool.php',
            'sources_custom/aws/Aws/ConfigService/ConfigServiceClient.php',
            'sources_custom/aws/Aws/ConfigService/Exception/ConfigServiceException.php',
            'sources_custom/aws/Aws/Credentials/CredentialProvider.php',
            'sources_custom/aws/Aws/Credentials/Credentials.php',
            'sources_custom/aws/Aws/Credentials/CredentialsInterface.php',
            'sources_custom/aws/Aws/Credentials/InstanceProfileProvider.php',
            'sources_custom/aws/Aws/DataPipeline/DataPipelineClient.php',
            'sources_custom/aws/Aws/DataPipeline/Exception/DataPipelineException.php',
            'sources_custom/aws/Aws/DatabaseMigrationService/DatabaseMigrationServiceClient.php',
            'sources_custom/aws/Aws/DatabaseMigrationService/Exception/DatabaseMigrationServiceException.php',
            'sources_custom/aws/Aws/DeviceFarm/DeviceFarmClient.php',
            'sources_custom/aws/Aws/DeviceFarm/Exception/DeviceFarmException.php',
            'sources_custom/aws/Aws/DirectConnect/DirectConnectClient.php',
            'sources_custom/aws/Aws/DirectConnect/Exception/DirectConnectException.php',
            'sources_custom/aws/Aws/DirectoryService/DirectoryServiceClient.php',
            'sources_custom/aws/Aws/DirectoryService/Exception/DirectoryServiceException.php',
            'sources_custom/aws/Aws/DoctrineCacheAdapter.php',
            'sources_custom/aws/Aws/DynamoDb/BinaryValue.php',
            'sources_custom/aws/Aws/DynamoDb/DynamoDbClient.php',
            'sources_custom/aws/Aws/DynamoDb/Exception/DynamoDbException.php',
            'sources_custom/aws/Aws/DynamoDb/LockingSessionConnection.php',
            'sources_custom/aws/Aws/DynamoDb/Marshaler.php',
            'sources_custom/aws/Aws/DynamoDb/NumberValue.php',
            'sources_custom/aws/Aws/DynamoDb/SessionConnectionInterface.php',
            'sources_custom/aws/Aws/DynamoDb/SessionHandler.php',
            'sources_custom/aws/Aws/DynamoDb/SetValue.php',
            'sources_custom/aws/Aws/DynamoDb/StandardSessionConnection.php',
            'sources_custom/aws/Aws/DynamoDb/WriteRequestBatch.php',
            'sources_custom/aws/Aws/DynamoDbStreams/DynamoDbStreamsClient.php',
            'sources_custom/aws/Aws/DynamoDbStreams/Exception/DynamoDbStreamsException.php',
            'sources_custom/aws/Aws/Ec2/CopySnapshotMiddleware.php',
            'sources_custom/aws/Aws/Ec2/Ec2Client.php',
            'sources_custom/aws/Aws/Ec2/Exception/Ec2Exception.php',
            'sources_custom/aws/Aws/Ecr/EcrClient.php',
            'sources_custom/aws/Aws/Ecr/Exception/EcrException.php',
            'sources_custom/aws/Aws/Ecs/EcsClient.php',
            'sources_custom/aws/Aws/Ecs/Exception/EcsException.php',
            'sources_custom/aws/Aws/Efs/EfsClient.php',
            'sources_custom/aws/Aws/Efs/Exception/EfsException.php',
            'sources_custom/aws/Aws/ElastiCache/ElastiCacheClient.php',
            'sources_custom/aws/Aws/ElastiCache/Exception/ElastiCacheException.php',
            'sources_custom/aws/Aws/ElasticBeanstalk/ElasticBeanstalkClient.php',
            'sources_custom/aws/Aws/ElasticBeanstalk/Exception/ElasticBeanstalkException.php',
            'sources_custom/aws/Aws/ElasticLoadBalancing/ElasticLoadBalancingClient.php',
            'sources_custom/aws/Aws/ElasticLoadBalancing/Exception/ElasticLoadBalancingException.php',
            'sources_custom/aws/Aws/ElasticTranscoder/ElasticTranscoderClient.php',
            'sources_custom/aws/Aws/ElasticTranscoder/Exception/ElasticTranscoderException.php',
            'sources_custom/aws/Aws/ElasticsearchService/ElasticsearchServiceClient.php',
            'sources_custom/aws/Aws/ElasticsearchService/Exception/ElasticsearchServiceException.php',
            'sources_custom/aws/Aws/Emr/EmrClient.php',
            'sources_custom/aws/Aws/Emr/Exception/EmrException.php',
            'sources_custom/aws/Aws/Endpoint/EndpointProvider.php',
            'sources_custom/aws/Aws/Endpoint/PatternEndpointProvider.php',
            'sources_custom/aws/Aws/Exception/AwsException.php',
            'sources_custom/aws/Aws/Exception/CouldNotCreateChecksumException.php',
            'sources_custom/aws/Aws/Exception/CredentialsException.php',
            'sources_custom/aws/Aws/Exception/MultipartUploadException.php',
            'sources_custom/aws/Aws/Exception/UnresolvedApiException.php',
            'sources_custom/aws/Aws/Exception/UnresolvedEndpointException.php',
            'sources_custom/aws/Aws/Exception/UnresolvedSignatureException.php',
            'sources_custom/aws/Aws/Firehose/Exception/FirehoseException.php',
            'sources_custom/aws/Aws/Firehose/FirehoseClient.php',
            'sources_custom/aws/Aws/GameLift/Exception/GameLiftException.php',
            'sources_custom/aws/Aws/GameLift/GameLiftClient.php',
            'sources_custom/aws/Aws/Glacier/Exception/GlacierException.php',
            'sources_custom/aws/Aws/Glacier/GlacierClient.php',
            'sources_custom/aws/Aws/Glacier/MultipartUploader.php',
            'sources_custom/aws/Aws/Glacier/TreeHash.php',
            'sources_custom/aws/Aws/Handler/GuzzleV5/GuzzleHandler.php',
            'sources_custom/aws/Aws/Handler/GuzzleV5/GuzzleStream.php',
            'sources_custom/aws/Aws/Handler/GuzzleV5/PsrStream.php',
            'sources_custom/aws/Aws/Handler/GuzzleV6/GuzzleHandler.php',
            'sources_custom/aws/Aws/HandlerList.php',
            'sources_custom/aws/Aws/HasDataTrait.php',
            'sources_custom/aws/Aws/HashInterface.php',
            'sources_custom/aws/Aws/HashingStream.php',
            'sources_custom/aws/Aws/History.php',
            'sources_custom/aws/Aws/Iam/Exception/IamException.php',
            'sources_custom/aws/Aws/Iam/IamClient.php',
            'sources_custom/aws/Aws/Inspector/Exception/InspectorException.php',
            'sources_custom/aws/Aws/Inspector/InspectorClient.php',
            'sources_custom/aws/Aws/Iot/Exception/IotException.php',
            'sources_custom/aws/Aws/Iot/IotClient.php',
            'sources_custom/aws/Aws/IotDataPlane/Exception/IotDataPlaneException.php',
            'sources_custom/aws/Aws/IotDataPlane/IotDataPlaneClient.php',
            'sources_custom/aws/Aws/JsonCompiler.php',
            'sources_custom/aws/Aws/Kinesis/Exception/KinesisException.php',
            'sources_custom/aws/Aws/Kinesis/KinesisClient.php',
            'sources_custom/aws/Aws/Kms/Exception/KmsException.php',
            'sources_custom/aws/Aws/Kms/KmsClient.php',
            'sources_custom/aws/Aws/Lambda/Exception/LambdaException.php',
            'sources_custom/aws/Aws/Lambda/LambdaClient.php',
            'sources_custom/aws/Aws/LruArrayCache.php',
            'sources_custom/aws/Aws/MachineLearning/Exception/MachineLearningException.php',
            'sources_custom/aws/Aws/MachineLearning/MachineLearningClient.php',
            'sources_custom/aws/Aws/MarketplaceCommerceAnalytics/Exception/MarketplaceCommerceAnalyticsException.php',
            'sources_custom/aws/Aws/MarketplaceCommerceAnalytics/MarketplaceCommerceAnalyticsClient.php',
            'sources_custom/aws/Aws/MarketplaceMetering/Exception/MarketplaceMeteringException.php',
            'sources_custom/aws/Aws/MarketplaceMetering/MarketplaceMeteringClient.php',
            'sources_custom/aws/Aws/Middleware.php',
            'sources_custom/aws/Aws/MockHandler.php',
            'sources_custom/aws/Aws/MultiRegionClient.php',
            'sources_custom/aws/Aws/Multipart/AbstractUploadManager.php',
            'sources_custom/aws/Aws/Multipart/AbstractUploader.php',
            'sources_custom/aws/Aws/Multipart/UploadState.php',
            'sources_custom/aws/Aws/OpsWorks/Exception/OpsWorksException.php',
            'sources_custom/aws/Aws/OpsWorks/OpsWorksClient.php',
            'sources_custom/aws/Aws/PhpHash.php',
            'sources_custom/aws/Aws/PsrCacheAdapter.php',
            'sources_custom/aws/Aws/Rds/Exception/RdsException.php',
            'sources_custom/aws/Aws/Rds/RdsClient.php',
            'sources_custom/aws/Aws/Redshift/Exception/RedshiftException.php',
            'sources_custom/aws/Aws/Redshift/RedshiftClient.php',
            'sources_custom/aws/Aws/Result.php',
            'sources_custom/aws/Aws/ResultInterface.php',
            'sources_custom/aws/Aws/ResultPaginator.php',
            'sources_custom/aws/Aws/RetryMiddleware.php',
            'sources_custom/aws/Aws/Route53/Exception/Route53Exception.php',
            'sources_custom/aws/Aws/Route53/Route53Client.php',
            'sources_custom/aws/Aws/Route53Domains/Exception/Route53DomainsException.php',
            'sources_custom/aws/Aws/Route53Domains/Route53DomainsClient.php',
            'sources_custom/aws/Aws/S3/AmbiguousSuccessParser.php',
            'sources_custom/aws/Aws/S3/ApplyChecksumMiddleware.php',
            'sources_custom/aws/Aws/S3/BatchDelete.php',
            'sources_custom/aws/Aws/S3/BucketEndpointMiddleware.php',
            'sources_custom/aws/Aws/S3/Exception/DeleteMultipleObjectsException.php',
            'sources_custom/aws/Aws/S3/Exception/PermanentRedirectException.php',
            'sources_custom/aws/Aws/S3/Exception/S3Exception.php',
            'sources_custom/aws/Aws/S3/GetBucketLocationParser.php',
            'sources_custom/aws/Aws/S3/MultipartCopy.php',
            'sources_custom/aws/Aws/S3/MultipartUploader.php',
            'sources_custom/aws/Aws/S3/MultipartUploadingTrait.php',
            'sources_custom/aws/Aws/S3/ObjectCopier.php',
            'sources_custom/aws/Aws/S3/ObjectUploader.php',
            'sources_custom/aws/Aws/S3/PermanentRedirectMiddleware.php',
            'sources_custom/aws/Aws/S3/PostObject.php',
            'sources_custom/aws/Aws/S3/PutObjectUrlMiddleware.php',
            'sources_custom/aws/Aws/S3/RetryableMalformedResponseParser.php',
            'sources_custom/aws/Aws/S3/S3Client.php',
            'sources_custom/aws/Aws/S3/S3ClientInterface.php',
            'sources_custom/aws/Aws/S3/S3ClientTrait.php',
            'sources_custom/aws/Aws/S3/S3MultiRegionClient.php',
            'sources_custom/aws/Aws/S3/S3UriParser.php',
            'sources_custom/aws/Aws/S3/SSECMiddleware.php',
            'sources_custom/aws/Aws/S3/StreamWrapper.php',
            'sources_custom/aws/Aws/S3/Transfer.php',
            'sources_custom/aws/Aws/Sdk.php',
            'sources_custom/aws/Aws/Ses/Exception/SesException.php',
            'sources_custom/aws/Aws/Ses/SesClient.php',
            'sources_custom/aws/Aws/Signature/AnonymousSignature.php',
            'sources_custom/aws/Aws/Signature/S3SignatureV4.php',
            'sources_custom/aws/Aws/Signature/SignatureInterface.php',
            'sources_custom/aws/Aws/Signature/SignatureProvider.php',
            'sources_custom/aws/Aws/Signature/SignatureV4.php',
            'sources_custom/aws/Aws/Sns/Exception/InvalidSnsMessageException.php',
            'sources_custom/aws/Aws/Sns/Exception/SnsException.php',
            'sources_custom/aws/Aws/Sns/Message.php',
            'sources_custom/aws/Aws/Sns/MessageValidator.php',
            'sources_custom/aws/Aws/Sns/SnsClient.php',
            'sources_custom/aws/Aws/Sqs/Exception/SqsException.php',
            'sources_custom/aws/Aws/Sqs/SqsClient.php',
            'sources_custom/aws/Aws/Ssm/Exception/SsmException.php',
            'sources_custom/aws/Aws/Ssm/SsmClient.php',
            'sources_custom/aws/Aws/StorageGateway/Exception/StorageGatewayException.php',
            'sources_custom/aws/Aws/StorageGateway/StorageGatewayClient.php',
            'sources_custom/aws/Aws/Sts/Exception/StsException.php',
            'sources_custom/aws/Aws/Sts/StsClient.php',
            'sources_custom/aws/Aws/Support/Exception/SupportException.php',
            'sources_custom/aws/Aws/Support/SupportClient.php',
            'sources_custom/aws/Aws/Swf/Exception/SwfException.php',
            'sources_custom/aws/Aws/Swf/SwfClient.php',
            'sources_custom/aws/Aws/TraceMiddleware.php',
            'sources_custom/aws/Aws/Waf/Exception/WafException.php',
            'sources_custom/aws/Aws/Waf/WafClient.php',
            'sources_custom/aws/Aws/Waiter.php',
            'sources_custom/aws/Aws/WorkSpaces/Exception/WorkSpacesException.php',
            'sources_custom/aws/Aws/WorkSpaces/WorkSpacesClient.php',
            'sources_custom/aws/Aws/WrappedHttpHandler.php',
            'sources_custom/aws/Aws/data/acm/2015-12-08/api-2.json.php',
            'sources_custom/aws/Aws/data/acm/2015-12-08/paginators-1.json.php',
            'sources_custom/aws/Aws/data/apigateway/2015-07-09/api-2.json.php',
            'sources_custom/aws/Aws/data/apigateway/2015-07-09/paginators-1.json.php',
            'sources_custom/aws/Aws/data/autoscaling/2011-01-01/api-2.json.php',
            'sources_custom/aws/Aws/data/autoscaling/2011-01-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/autoscaling/2011-01-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/cloudformation/2010-05-15/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudformation/2010-05-15/paginators-1.json.php',
            'sources_custom/aws/Aws/data/cloudformation/2010-05-15/waiters-2.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2015-07-27/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2015-07-27/paginators-1.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2015-07-27/waiters-2.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2016-01-28/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2016-01-28/paginators-1.json.php',
            'sources_custom/aws/Aws/data/cloudfront/2016-01-28/waiters-2.json.php',
            'sources_custom/aws/Aws/data/cloudhsm/2014-05-30/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudsearch/2013-01-01/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudsearch/2013-01-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/cloudsearchdomain/2013-01-01/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudtrail/2013-11-01/api-2.json.php',
            'sources_custom/aws/Aws/data/cloudtrail/2013-11-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/codecommit/2015-04-13/api-2.json.php',
            'sources_custom/aws/Aws/data/codecommit/2015-04-13/paginators-1.json.php',
            'sources_custom/aws/Aws/data/codedeploy/2014-10-06/api-2.json.php',
            'sources_custom/aws/Aws/data/codedeploy/2014-10-06/paginators-1.json.php',
            'sources_custom/aws/Aws/data/codepipeline/2015-07-09/api-2.json.php',
            'sources_custom/aws/Aws/data/cognito-identity/2014-06-30/api-2.json.php',
            'sources_custom/aws/Aws/data/cognito-sync/2014-06-30/api-2.json.php',
            'sources_custom/aws/Aws/data/config/2014-11-12/api-2.json.php',
            'sources_custom/aws/Aws/data/config/2014-11-12/paginators-1.json.php',
            'sources_custom/aws/Aws/data/data.iot/2015-05-28/api-2.json.php',
            'sources_custom/aws/Aws/data/datapipeline/2012-10-29/api-2.json.php',
            'sources_custom/aws/Aws/data/datapipeline/2012-10-29/paginators-1.json.php',
            'sources_custom/aws/Aws/data/devicefarm/2015-06-23/api-2.json.php',
            'sources_custom/aws/Aws/data/devicefarm/2015-06-23/paginators-1.json.php',
            'sources_custom/aws/Aws/data/directconnect/2012-10-25/api-2.json.php',
            'sources_custom/aws/Aws/data/directconnect/2012-10-25/paginators-1.json.php',
            'sources_custom/aws/Aws/data/dms/2016-01-01/api-2.json.php',
            'sources_custom/aws/Aws/data/ds/2015-04-16/api-2.json.php',
            'sources_custom/aws/Aws/data/dynamodb/2012-08-10/api-2.json.php',
            'sources_custom/aws/Aws/data/dynamodb/2012-08-10/paginators-1.json.php',
            'sources_custom/aws/Aws/data/dynamodb/2012-08-10/waiters-2.json.php',
            'sources_custom/aws/Aws/data/ec2/2015-10-01/api-2.json.php',
            'sources_custom/aws/Aws/data/ec2/2015-10-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/ec2/2015-10-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/ecr/2015-09-21/api-2.json.php',
            'sources_custom/aws/Aws/data/ecs/2014-11-13/api-2.json.php',
            'sources_custom/aws/Aws/data/ecs/2014-11-13/paginators-1.json.php',
            'sources_custom/aws/Aws/data/ecs/2014-11-13/waiters-2.json.php',
            'sources_custom/aws/Aws/data/elasticache/2015-02-02/api-2.json.php',
            'sources_custom/aws/Aws/data/elasticache/2015-02-02/paginators-1.json.php',
            'sources_custom/aws/Aws/data/elasticache/2015-02-02/waiters-2.json.php',
            'sources_custom/aws/Aws/data/elasticbeanstalk/2010-12-01/api-2.json.php',
            'sources_custom/aws/Aws/data/elasticbeanstalk/2010-12-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/elasticfilesystem/2015-02-01/api-2.json.php',
            'sources_custom/aws/Aws/data/elasticloadbalancing/2012-06-01/api-2.json.php',
            'sources_custom/aws/Aws/data/elasticloadbalancing/2012-06-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/elasticloadbalancing/2012-06-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/elasticmapreduce/2009-03-31/api-2.json.php',
            'sources_custom/aws/Aws/data/elasticmapreduce/2009-03-31/paginators-1.json.php',
            'sources_custom/aws/Aws/data/elasticmapreduce/2009-03-31/waiters-2.json.php',
            'sources_custom/aws/Aws/data/elastictranscoder/2012-09-25/api-2.json.php',
            'sources_custom/aws/Aws/data/elastictranscoder/2012-09-25/paginators-1.json.php',
            'sources_custom/aws/Aws/data/elastictranscoder/2012-09-25/waiters-2.json.php',
            'sources_custom/aws/Aws/data/email/2010-12-01/api-2.json.php',
            'sources_custom/aws/Aws/data/email/2010-12-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/email/2010-12-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/endpoints.json.php',
            'sources_custom/aws/Aws/data/es/2015-01-01/api-2.json.php',
            'sources_custom/aws/Aws/data/events/2015-10-07/api-2.json.php',
            'sources_custom/aws/Aws/data/firehose/2015-08-04/api-2.json.php',
            'sources_custom/aws/Aws/data/gamelift/2015-10-01/api-2.json.php',
            'sources_custom/aws/Aws/data/glacier/2012-06-01/api-2.json.php',
            'sources_custom/aws/Aws/data/glacier/2012-06-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/glacier/2012-06-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/iam/2010-05-08/api-2.json.php',
            'sources_custom/aws/Aws/data/iam/2010-05-08/paginators-1.json.php',
            'sources_custom/aws/Aws/data/iam/2010-05-08/waiters-2.json.php',
            'sources_custom/aws/Aws/data/inspector/2016-02-16/api-2.json.php',
            'sources_custom/aws/Aws/data/iot/2015-05-28/api-2.json.php',
            'sources_custom/aws/Aws/data/kinesis/2013-12-02/api-2.json.php',
            'sources_custom/aws/Aws/data/kinesis/2013-12-02/paginators-1.json.php',
            'sources_custom/aws/Aws/data/kinesis/2013-12-02/waiters-2.json.php',
            'sources_custom/aws/Aws/data/kms/2014-11-01/api-2.json.php',
            'sources_custom/aws/Aws/data/kms/2014-11-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/lambda/2015-03-31/api-2.json.php',
            'sources_custom/aws/Aws/data/lambda/2015-03-31/paginators-1.json.php',
            'sources_custom/aws/Aws/data/logs/2014-03-28/api-2.json.php',
            'sources_custom/aws/Aws/data/logs/2014-03-28/paginators-1.json.php',
            'sources_custom/aws/Aws/data/machinelearning/2014-12-12/api-2.json.php',
            'sources_custom/aws/Aws/data/machinelearning/2014-12-12/paginators-1.json.php',
            'sources_custom/aws/Aws/data/machinelearning/2014-12-12/waiters-2.json.php',
            'sources_custom/aws/Aws/data/manifest.json.php',
            'sources_custom/aws/Aws/data/marketplacecommerceanalytics/2015-07-01/api-2.json.php',
            'sources_custom/aws/Aws/data/metering.marketplace/2016-01-14/api-2.json.php',
            'sources_custom/aws/Aws/data/monitoring/2010-08-01/api-2.json.php',
            'sources_custom/aws/Aws/data/monitoring/2010-08-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/opsworks/2013-02-18/api-2.json.php',
            'sources_custom/aws/Aws/data/opsworks/2013-02-18/paginators-1.json.php',
            'sources_custom/aws/Aws/data/opsworks/2013-02-18/waiters-2.json.php',
            'sources_custom/aws/Aws/data/rds/2014-10-31/api-2.json.php',
            'sources_custom/aws/Aws/data/rds/2014-10-31/paginators-1.json.php',
            'sources_custom/aws/Aws/data/rds/2014-10-31/waiters-2.json.php',
            'sources_custom/aws/Aws/data/redshift/2012-12-01/api-2.json.php',
            'sources_custom/aws/Aws/data/redshift/2012-12-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/redshift/2012-12-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/route53/2013-04-01/api-2.json.php',
            'sources_custom/aws/Aws/data/route53/2013-04-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/route53/2013-04-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/route53domains/2014-05-15/api-2.json.php',
            'sources_custom/aws/Aws/data/route53domains/2014-05-15/paginators-1.json.php',
            'sources_custom/aws/Aws/data/s3/2006-03-01/api-2.json.php',
            'sources_custom/aws/Aws/data/s3/2006-03-01/paginators-1.json.php',
            'sources_custom/aws/Aws/data/s3/2006-03-01/waiters-2.json.php',
            'sources_custom/aws/Aws/data/sns/2010-03-31/api-2.json.php',
            'sources_custom/aws/Aws/data/sns/2010-03-31/paginators-1.json.php',
            'sources_custom/aws/Aws/data/sqs/2012-11-05/api-2.json.php',
            'sources_custom/aws/Aws/data/sqs/2012-11-05/paginators-1.json.php',
            'sources_custom/aws/Aws/data/sqs/2012-11-05/waiters-2.json.php',
            'sources_custom/aws/Aws/data/ssm/2014-11-06/api-2.json.php',
            'sources_custom/aws/Aws/data/ssm/2014-11-06/paginators-1.json.php',
            'sources_custom/aws/Aws/data/storagegateway/2013-06-30/api-2.json.php',
            'sources_custom/aws/Aws/data/storagegateway/2013-06-30/paginators-1.json.php',
            'sources_custom/aws/Aws/data/streams.dynamodb/2012-08-10/api-2.json.php',
            'sources_custom/aws/Aws/data/sts/2011-06-15/api-2.json.php',
            'sources_custom/aws/Aws/data/support/2013-04-15/api-2.json.php',
            'sources_custom/aws/Aws/data/support/2013-04-15/paginators-1.json.php',
            'sources_custom/aws/Aws/data/swf/2012-01-25/api-2.json.php',
            'sources_custom/aws/Aws/data/swf/2012-01-25/paginators-1.json.php',
            'sources_custom/aws/Aws/data/waf/2015-08-24/api-2.json.php',
            'sources_custom/aws/Aws/data/workspaces/2015-04-08/api-2.json.php',
            'sources_custom/aws/Aws/data/workspaces/2015-04-08/paginators-1.json.php',
            'sources_custom/aws/Aws/functions.php',
            'sources_custom/aws/CHANGELOG.md',
            'sources_custom/aws/GuzzleHttp/Client.php',
            'sources_custom/aws/GuzzleHttp/ClientInterface.php',
            'sources_custom/aws/GuzzleHttp/Cookie/CookieJar.php',
            'sources_custom/aws/GuzzleHttp/Cookie/CookieJarInterface.php',
            'sources_custom/aws/GuzzleHttp/Cookie/FileCookieJar.php',
            'sources_custom/aws/GuzzleHttp/Cookie/SessionCookieJar.php',
            'sources_custom/aws/GuzzleHttp/Cookie/SetCookie.php',
            'sources_custom/aws/GuzzleHttp/Exception/BadResponseException.php',
            'sources_custom/aws/GuzzleHttp/Exception/ClientException.php',
            'sources_custom/aws/GuzzleHttp/Exception/ConnectException.php',
            'sources_custom/aws/GuzzleHttp/Exception/GuzzleException.php',
            'sources_custom/aws/GuzzleHttp/Exception/RequestException.php',
            'sources_custom/aws/GuzzleHttp/Exception/SeekException.php',
            'sources_custom/aws/GuzzleHttp/Exception/ServerException.php',
            'sources_custom/aws/GuzzleHttp/Exception/TooManyRedirectsException.php',
            'sources_custom/aws/GuzzleHttp/Exception/TransferException.php',
            'sources_custom/aws/GuzzleHttp/Handler/CurlFactory.php',
            'sources_custom/aws/GuzzleHttp/Handler/CurlFactoryInterface.php',
            'sources_custom/aws/GuzzleHttp/Handler/CurlHandler.php',
            'sources_custom/aws/GuzzleHttp/Handler/CurlMultiHandler.php',
            'sources_custom/aws/GuzzleHttp/Handler/EasyHandle.php',
            'sources_custom/aws/GuzzleHttp/Handler/MockHandler.php',
            'sources_custom/aws/GuzzleHttp/Handler/Proxy.php',
            'sources_custom/aws/GuzzleHttp/Handler/StreamHandler.php',
            'sources_custom/aws/GuzzleHttp/HandlerStack.php',
            'sources_custom/aws/GuzzleHttp/MessageFormatter.php',
            'sources_custom/aws/GuzzleHttp/Middleware.php',
            'sources_custom/aws/GuzzleHttp/Pool.php',
            'sources_custom/aws/GuzzleHttp/PrepareBodyMiddleware.php',
            'sources_custom/aws/GuzzleHttp/Promise/AggregateException.php',
            'sources_custom/aws/GuzzleHttp/Promise/CancellationException.php',
            'sources_custom/aws/GuzzleHttp/Promise/EachPromise.php',
            'sources_custom/aws/GuzzleHttp/Promise/FulfilledPromise.php',
            'sources_custom/aws/GuzzleHttp/Promise/Promise.php',
            'sources_custom/aws/GuzzleHttp/Promise/PromiseInterface.php',
            'sources_custom/aws/GuzzleHttp/Promise/PromisorInterface.php',
            'sources_custom/aws/GuzzleHttp/Promise/RejectedPromise.php',
            'sources_custom/aws/GuzzleHttp/Promise/RejectionException.php',
            'sources_custom/aws/GuzzleHttp/Promise/TaskQueue.php',
            'sources_custom/aws/GuzzleHttp/Promise/functions.php',
            'sources_custom/aws/GuzzleHttp/Promise/functions_include.php',
            'sources_custom/aws/GuzzleHttp/Psr7/AppendStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/BufferStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/CachingStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/DroppingStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/FnStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/InflateStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/LazyOpenStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/LimitStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/MessageTrait.php',
            'sources_custom/aws/GuzzleHttp/Psr7/MultipartStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/NoSeekStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/PumpStream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/Request.php',
            'sources_custom/aws/GuzzleHttp/Psr7/Response.php',
            'sources_custom/aws/GuzzleHttp/Psr7/Stream.php',
            'sources_custom/aws/GuzzleHttp/Psr7/StreamDecoratorTrait.php',
            'sources_custom/aws/GuzzleHttp/Psr7/StreamWrapper.php',
            'sources_custom/aws/GuzzleHttp/Psr7/Uri.php',
            'sources_custom/aws/GuzzleHttp/Psr7/functions.php',
            'sources_custom/aws/GuzzleHttp/Psr7/functions_include.php',
            'sources_custom/aws/GuzzleHttp/RedirectMiddleware.php',
            'sources_custom/aws/GuzzleHttp/RequestOptions.php',
            'sources_custom/aws/GuzzleHttp/RetryMiddleware.php',
            'sources_custom/aws/GuzzleHttp/TransferStats.php',
            'sources_custom/aws/GuzzleHttp/UriTemplate.php',
            'sources_custom/aws/GuzzleHttp/functions.php',
            'sources_custom/aws/GuzzleHttp/functions_include.php',
            'sources_custom/aws/JmesPath/AstRuntime.php',
            'sources_custom/aws/JmesPath/CompilerRuntime.php',
            'sources_custom/aws/JmesPath/DebugRuntime.php',
            'sources_custom/aws/JmesPath/Env.php',
            'sources_custom/aws/JmesPath/FnDispatcher.php',
            'sources_custom/aws/JmesPath/JmesPath.php',
            'sources_custom/aws/JmesPath/Lexer.php',
            'sources_custom/aws/JmesPath/Parser.php',
            'sources_custom/aws/JmesPath/SyntaxErrorException.php',
            'sources_custom/aws/JmesPath/TreeCompiler.php',
            'sources_custom/aws/JmesPath/TreeInterpreter.php',
            'sources_custom/aws/JmesPath/Utils.php',
            'sources_custom/aws/LICENSE.md',
            'sources_custom/aws/NOTICE.md',
            'sources_custom/aws/Psr/Http/Message/MessageInterface.php',
            'sources_custom/aws/Psr/Http/Message/RequestInterface.php',
            'sources_custom/aws/Psr/Http/Message/ResponseInterface.php',
            'sources_custom/aws/Psr/Http/Message/ServerRequestInterface.php',
            'sources_custom/aws/Psr/Http/Message/StreamInterface.php',
            'sources_custom/aws/Psr/Http/Message/UploadedFileInterface.php',
            'sources_custom/aws/Psr/Http/Message/UriInterface.php',
            'sources_custom/aws/README.md',
            'sources_custom/aws/aws-autoloader.php',
        );
    }
}
