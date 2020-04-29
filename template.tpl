___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Elevar Monitoring Tag Info",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const addEventCallback = require("addEventCallback");
const createQueue = require("createQueue");

const TAG_INFO = "elevar_gtm_tag_info";
const addInfo = createQueue(TAG_INFO);

addEventCallback(function(containerId, eventData) {
  	const tags = eventData.tags.filter(tag => tag.name);

	tags.forEach(tag => {
    	addInfo({
        	channel: tag.channel,
          	tagName: tag.name,
          	eventId: data.gtmEventId,
          	variables: typeof tag.variables === 'string' ?
          		tag.variables.split(',').map(variable => variable.trim())
          		: undefined
        });
    });
});

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "elevar_gtm_tag_info"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_metadata",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: has basic info
  code: |-
    eventData.tags = [
      {
        name: 'Tag - 3',
        executionTime: 1,
        id: 286,
        status: "success"
      }
    ];

    const mockData = {
      gtmTagId: 2147483645,
      gtmEventId: 13
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertThat(window[TAG_INFO]).hasLength(1);
    assertThat(window[TAG_INFO][0].tagName).isEqualTo("Tag - 3");
    assertThat(window[TAG_INFO][0].eventId).isEqualTo(13);
- name: no Name
  code: |-
    eventData.tags = [
      {
        channel: 'facebook',
        variables: 'var 1, var 2',
        executionTime: 1,
        id: 286,
        status: "success"
      }
    ];

    const mockData = {
      gtmTagId: 2147483645,
      gtmEventId: 13
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertThat(window[TAG_INFO]).hasLength(0);
- name: with Variables
  code: |-
    eventData.tags = [
      {
        name: 'Tag - 1',
        variables: 'var - 1, var - 2',
        executionTime: 1,
        id: 286,
        status: "success"
      }
    ];

    const mockData = {
      gtmTagId: 2147483645,
      gtmEventId: 13
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

    assertThat(window[TAG_INFO]).hasLength(1);
    assertThat(window[TAG_INFO][0].variables).isEqualTo(['var - 1', 'var - 2']);
- name: with Channel
  code: |-
    eventData.tags = [
      {
        name: 'Tag - 1',
        channel: 'facebook',
        executionTime: 1,
        id: 286,
        status: "success"
      }
    ];

    const mockData = {
      gtmTagId: 2147483645,
      gtmEventId: 13
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

    assertThat(window[TAG_INFO]).hasLength(1);
    assertThat(window[TAG_INFO][0].channel).isEqualTo('facebook');
- name: multiple tags
  code: |-
    eventData.tags = [
      {
        name: 'Tag - 1',
        executionTime: 1,
        id: 286,
        status: "success"
      },
      {
        name: 'Tag - 2',
        executionTime: 1,
        id: 287,
        status: "success"
      },
      {
        name: 'Tag - 3',
        executionTime: 1,
        id: 288,
        status: "success"
      }
    ];

    const mockData = {
      gtmTagId: 2147483645,
      gtmEventId: 13
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

    assertThat(window[TAG_INFO]).hasLength(3);
    assertThat(window[TAG_INFO][0].tagName).isEqualTo('Tag - 1');
    assertThat(window[TAG_INFO][0].eventId).isEqualTo(13);
    assertThat(window[TAG_INFO][1].tagName).isEqualTo('Tag - 2');
    assertThat(window[TAG_INFO][1].eventId).isEqualTo(13);
    assertThat(window[TAG_INFO][2].tagName).isEqualTo('Tag - 3');
    assertThat(window[TAG_INFO][2].eventId).isEqualTo(13);
setup: "const log = require('logToConsole');\n\nconst TAG_INFO = \"elevar_gtm_tag_info\"\
  ;\nlet window = {};\nlet eventData = {\n  tags: []\n};\n\nmock(\"addEventCallback\"\
  , callback => {\n  callback('GTM-12345678', eventData);\n});\n\n/*\nCreates an array\
  \ in the window with the key provided and\nreturns a function that pushes items\
  \ to that array.\n*/\nmock('createQueue', (key) => {\n  const pushToArray = (arr)\
  \ => (item) => {\n    arr.push(item);\n  };\n  \n  if (!window[key]) window[key]\
  \ = [];\n  return pushToArray(window[key]);\n});"


___NOTES___

Created on 29/04/2020, 10:50:52


