var config = {
    defaults: {
        standard: 'WCAG2AA',
        // ignore issue with role=presentation on start button
        ignore: ["WCAG2AA.Principle1.Guideline1_3.1_3_1.F92,ARIA4"],
        timeout: 15000,
        wait: 1500,
        chromeLaunchConfig: {
            args: [
                "--no-sandbox"
            ]
        },
        hideElements: [".govuk-header__logotype-crown", ".govuk-footer__licence-logo"]
    },
    urls: [
        '${BASE_URL}',
        "${BASE_URL}/vehicle_checkers/enter_details",
        {
            "url": "${BASE_URL}?confirm-details",
            "actions": [
                "click element .govuk-button--start",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS310",
				"click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible"
            ]
        },
        {
            "url": "${BASE_URL}?caz-selection",
            "actions": [
                "click element .govuk-button--start",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS310",
				"click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #caz-0 to be visible"
            ]
        },
        {
            "url": "${BASE_URL}?compliance",
            "actions": [
                "click element .govuk-button--start",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS310",
				"click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #caz-0 to be visible",
                "check field #caz-0",
                "check field #caz-1",
                "click element input[type=submit]",
            ]
        },
		{
            "url": "${BASE_URL}?exemption",
            "actions": [
                "click element .govuk-button--start",
                "wait for element #vrn to be visible",
                "set field #vrn to CU57ABE",
				"click element #registration-country-1",
                "click element input[type=submit]"
            ]
        },
		{
            "url": "${BASE_URL}?incorrect-vehicle",
            "actions": [
                "click element .govuk-button--start",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS310",
				"click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-2 to be visible",
                "click element #confirm-vehicle-2",
                "click element input[type=submit]",
                "wait for element [href='/vehicle_checkers/enter_details'] to be visible"
            ]
        }
    ]
};

/**
 * Simple method to replace nested URLs in a pa11y configuration definition
 */
function replacePa11yBaseUrls(urls, defaults) {

    console.error('BASE_URL:', process.env.BASE_URL);

    //Iterate existing urls object from configuration
    for (var idx = 0; idx < urls.length; idx++) {
        if (typeof urls[idx] === 'object') {
            // If configuration object in URLs is a further nested object, replace inner url field value
            var nestedObject = urls[idx]
            nestedObject['url'] = nestedObject['url'].replace('${BASE_URL}', process.env.BASE_URL)
            urls[idx] = nestedObject;
        } else {
            // Otherwise replace simple string (see pa11y configuration guidance)
            urls[idx] = urls[idx].replace('${BASE_URL}', process.env.BASE_URL);
        }
    }

    result = {
        defaults: defaults,
        urls: urls
    }

	console.log('\n')
	console.log('Generated pa11y configuration:\n')
	console.log(result)
	
    return result
};

module.exports = replacePa11yBaseUrls(config.urls, config.defaults);
