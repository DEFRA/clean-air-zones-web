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
        '${BASE_URL}?login',
        {
            "url": "${BASE_URL}?your_account",
            "actions": [
                "wait for element #ccc-dismiss-button to be visible",
                "click element #ccc-dismiss-button ",
                "wait for element #user_email to be visible",
                "set field #user_email to tester@informed.com",
                "set field #user_password to Tester123..",
                "click element [name='commit']",
            ]
        },
        "${BASE_URL}/cookies",
        "${BASE_URL}/privacy_notice",
        "${BASE_URL}/accessibility_statement",
        "${BASE_URL}/fleets",
        "${BASE_URL}/uploads",
        "${BASE_URL}/debits"
        
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
