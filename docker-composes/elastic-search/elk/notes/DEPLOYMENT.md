# Deployment Guide for ELK Stack with Docker

This guide provides step-by-step instructions to deploy an ELK (Elasticsearch, Logstash, Kibana) stack using Docker, with a focus on securing the setup using self-signed SSL certificates and encryption keys.

- Environment variables configured (`.env` file)

## LOGSTASH_SCHEDULE

This is an environment variable set on all scheduled jobs that sync data from databases into elastic search, the idea
of having this as environment variable is configured that dynamically as we need.

## encryptionKey

`xpack.encryptedSavedObjects.encryptionKey`
In the kibana.yml configuration file, the setting xpack.encryptedSavedObjects.encryptionKey is used to specify an encryption key for encrypting sensitive saved objects within Kibana.

```yaml
xpack.encryptedSavedObjects.encryptionKey: ${KIBANA_XPACK_ENCRYPTION_KEY}
```

## Generate random hex key for kibana

To generate a secure encryption key, we use the OpenSSL command-line tool to produce a random 32-byte hex string. This string is then set as the value for KIBANA_XPACK_ENCRYPTION_KEY in the environment.

```shell
 openssl rand -hex 32 
```
Save the value on .env file as `KIBANA_XPACK_ENCRYPTION_KEY`.

### Why This Works

- Security: The `xpack.encryptedSavedObjects.encryptionKey` is used to encrypt sensitive data stored within Kibana's 
saved objects, such as dashboards, visualizations, and configuration settings. By encrypting this data, we ensure that even if someone gains unauthorized access to the stored data, they cannot read it without the encryption key.

- Consistency: By setting the encryption key in the kibana.yml configuration file and referencing it through an 
environment variable (${KIBANA_XPACK_ENCRYPTION_KEY}), we ensure that the same encryption key is used consistently across Kibana restarts. This prevents issues with encrypted data becoming inaccessible due to key changes.

- Flexibility: Using an environment variable allows for easy management and rotation of the encryption key without 
hardcoding it in the configuration file. This is especially useful in automated deployments and for maintaining security best practices.

### Objective
The primary objective of the `xpack.encryptedSavedObjects.encryptionKey` setting is to enhance the security of Kibana by encrypting sensitive saved objects. This encryption helps protect:

User credentials
API keys
Sensitive configuration data
By encrypting this information, Kibana ensures that even if the underlying data storage is compromised, the sensitive information remains secure and unreadable without the encryption key.


## Other references links

There are other references links about securing ELK stack but we probably don't need it

- https://www.elastic.co/guide/en/kibana/current/using-kibana-with-security.html
- https://www.elastic.co/guide/en/kibana/current/kibana-encryption-keys.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-stack-security.html