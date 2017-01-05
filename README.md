# apartment-monitor

The apartment-monitor is a Python script to monitor apartments of housing cooperatives around Vienna. New web pages can be added quickly and painless.

## Setup

Currently sending mails is only possible through a GMail account. Hence you need to provide valid API credentials.
The process of getting an API key for your Google Account is described at https://developers.google.com/api-client-library/python/auth/api-keys.

Put the client_secret.json in the directory of the apartment-monitor. 

Create a file mail.json and configure the sender and receiver of the E-Mails:

```json
{
  "sender": "john.doe[at]gmail.com",
  "receiver": "john.doe[at]gmail.com"
}
```

You can then use any scheduler (i.e. cron) to regularly call the apartment-monitor.   

## Dependencies

httplib2
google-api-python-client

## Adding estate pages

To add new pages, simply edit the estate_pages.json. Currently the following fields are required:

* key: The unique key of the estate page. Must map to a valid filename. 
* url: The base URL of the estate page

Additionally, the following fields are supported:

* query: A regular expression to be applied to the raw XML/HTML content of the estate page after download
* headers: a JSON array of additional HTTP headers 
* data: The payload for the POST request.
* data_binary: The as-is payload for the POST request
* options: Additional options to be passed to pyCurl. See the pyCurl documentation for details. 
* charset: Overrides the default charset (UTF-8). Required when the page does not provide the charset in the Content-Type header, but also does not provide UTF-8 content. 