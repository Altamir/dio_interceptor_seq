const String CONTENT_TYPE_CLEF = 'application/vnd.serilog.clef';
const String SEQ_API_KEY = 'X-Seq-ApiKey';
const String ERROR_SEND_TO_SEQ = 'Error sending logs to Seq: ';
const String TEMPLATE_REQUEST =
    'REQUEST: {@method} {@path} {@debugId} {@data} {@queryParams} {@headers}';
const String TEMPLATE_RESPONSE =
    'RESPONSE: {@statusCode} {@path} {@debugId} {@data} {@headers} {@elapsedTime}';
const String TEMPLATE_ERRO =
    'ERROR: {@statusCode} {@path} {@debugId} {@message} {@errorData} {@headers} {@elapsedTime}';
