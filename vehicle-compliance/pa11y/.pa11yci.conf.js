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
        }
    },
    urls: [
        '${BASE_URL}?home_page',
        {
            "url": "${BASE_URL}?cookie_control",
            "actions": [
                "wait for element #ccc-dismiss-button to be visible",
                "click element #ccc-dismiss-button"
            ]
        },
        "${BASE_URL}/vehicle_checkers/enter_details",
        {
            "url": "${BASE_URL}?confirm_details",
            "actions": [
                "click element #start-now-button",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS338",
                "click element #registration-country-1",
                "click element #submit_enter_details_button",
                "wait for element #confirm_details-1 to be visible",
            ]
        },
        {
            "url": "${BASE_URL}?compliance",
            "actions": [
                "click element #start-now-button",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS338",
                "click element #registration-country-1",
                "click element #submit_enter_details_button",
                "wait for element #confirm_details-1 to be visible",
                "click element #confirm_details-1",
                "click element #submit_confirm_details_button",
                "wait for element #compliance-table to be visible"
            ]
        },
		    {
            "url": "${BASE_URL}?number_not_found",
            "actions": [
                "click element #start-now-button",
                "wait for element #vrn to be visible",
                "set field #vrn to CU57ABE",
                "click element #registration-country-1",
                "click element #submit_enter_details_button",
                "wait for element #dvla-link to be visible"
            ]
        },
		    {
            "url": "${BASE_URL}?incorrect_details",
            "actions": [
                "click element #start-now-button",
                "wait for element #vrn to be visible",
                "set field #vrn to CAS338",
                "click element #registration-country-1",
                "click element #submit_enter_details_button",
                "wait for element #confirm_details-2 to be visible",
                "click element #confirm_details-2",
                "click element #submit_confirm_details_button",
                "wait for element #check-another-vrn to be visible"
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
}

module.exports = replacePa11yBaseUrls(config.urls, config.defaults);
