# From devstack commit bd13b708f2 with no modifications

[DEFAULT]
public_port = 5000
admin_port = 35357
admin_token = %SERVICE_TOKEN%
compute_port = 3000
verbose = True
debug = True

# commented out so devstack logs to stdout
# log_file = %DEST%/keystone/keystone.log

# ================= Syslog Options ============================
# Send logs to syslog (/dev/log) instead of to file specified
# by `log-file`
use_syslog = False

# Facility to use. If unset defaults to LOG_USER.
# syslog_log_facility = LOG_LOCAL0

[sql]
connection = %SQL_CONN%
idle_timeout = 30
min_pool_size = 5
max_pool_size = 10
pool_timeout = 200

[identity]
driver = keystone.identity.backends.sql.Identity

[catalog]
driver = keystone.catalog.backends.templated.TemplatedCatalog
template_file = %KEYSTONE_DIR%/etc/default_catalog.templates

[token]
driver = keystone.token.backends.kvs.Token

[policy]
driver = keystone.policy.backends.simple.SimpleMatch

[ec2]
driver = keystone.contrib.ec2.backends.sql.Ec2

[filter:debug]
paste.filter_factory = keystone.common.wsgi:Debug.factory

[filter:token_auth]
paste.filter_factory = keystone.middleware:TokenAuthMiddleware.factory

[filter:admin_token_auth]
paste.filter_factory = keystone.middleware:AdminTokenAuthMiddleware.factory

[filter:json_body]
paste.filter_factory = keystone.middleware:JsonBodyMiddleware.factory

[filter:crud_extension]
paste.filter_factory = keystone.contrib.admin_crud:CrudExtension.factory

[filter:ec2_extension]
paste.filter_factory = keystone.contrib.ec2:Ec2Extension.factory

[app:public_service]
paste.app_factory = keystone.service:public_app_factory

[app:admin_service]
paste.app_factory = keystone.service:admin_app_factory

[pipeline:public_api]
pipeline = token_auth admin_token_auth json_body debug ec2_extension public_service

[pipeline:admin_api]
pipeline = token_auth admin_token_auth json_body debug ec2_extension crud_extension admin_service

[app:public_version_service]
paste.app_factory = keystone.service:public_version_app_factory

[app:admin_version_service]
paste.app_factory = keystone.service:admin_version_app_factory

[pipeline:public_version_api]
pipeline = public_version_service

[pipeline:admin_version_api]
pipeline = admin_version_service

[composite:main]
use = egg:Paste#urlmap
/v2.0 = public_api
/ = public_version_api

[composite:admin]
use = egg:Paste#urlmap
/v2.0 = admin_api
/ = admin_version_service
