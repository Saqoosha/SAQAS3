<?php
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, $_REQUEST['_url']);
curl_setopt($curl, CURLOPT_BUFFERSIZE, 1);
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
//curl_setopt($curl, CURLOPT_HEADER, true);
if (isset($_REQUEST['_header'])) {
	parse_str($_REQUEST['_header'], $_header);
	$headers = array();
	foreach ($_header as $key => $value) {
		array_push($headers, $key . ': ' . $value);
	}
	curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
}
if (strtolower($_REQUEST['_method']) == 'post') {
	curl_setopt($curl, CURLOPT_POST, true);
	curl_setopt($curl, CURLOPT_POSTFIELDS, $_REQUEST['_data']);
}
if (!curl_exec($curl)) {
	print curl_error($curl);
}

// print_r($_REQUEST);
// print_r($_header);
// print_r($headers);
