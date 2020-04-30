# [Elevar Monitoring](https://www.getelevar.com/marketing-tag-monitoring/) | Tag Info

The tag info template add's the option to attach tag information to your variable errors. This way, with a glance you'll know what marketing channels are affected by your GTM errors and you can act on them accordingly.

## Getting started

This guide will highlight the steps needed to setup the tag info template in your GTM container. Elevar monitoring templates require you to signup as a customer in the [Elevar Analytics Dashboard](app.getelevar.com).

### Prerequisite

To get the benefit of this template you will have to have setup the following templates:

1. [Elevar Monitoring Core Tag](https://github.com/getelevar/gtm-monitoring-core/blob/master/README.md)
2. [Elevar Monitoring Variable](https://github.com/getelevar/gtm-monitoring-variables/blob/master/README.md)

### Setup

1. Add the [Elevar Monitoring Tag Info template](https://tagmanager.google.com/gallery/#/?filter=elevar) to your GTM container.
2. Add a new trigger that fires on all events, if you don't already have one. This allows the Info Tag to see all tag activity.

   - Navigate to the triggers page and click on "New"
   - For the trigger type choose "Custom Event"
   - Turn on "use regex matching" and input `.*` as the event name. This will make the event match all events.
   - Save the trigger with a name of your choice

3. Add a new tag that is using the "Tag Info" template and that is triggered by the "all events" trigger we added in the previous step. Save the tag with a name of your choice.
4. Now you can add additional metadata to your already existing tags and the "Tag Info" template will save that data to be used with the variable errors. The tag doesn't do a thing if metadata is not added.

### Attaching Metadata to Tags

When you click on a tag that you want to add metadata to it opens the tag configuration drawer. At the bottom of this drawer you'll find the **"Advanced Settings"** dropdown and at the bottom of this drawer you'll find the **"Additional Tag Metadata"** dropdown. This will be where all the tag info metadata will be configured, this is what powers the Tag Info Template.

**Tag Name**

Each tag should have "Include tag name" box checked and the key configured as `name`. Without this no additional metadata will be recorded.

**Variable Info**

Each tag should have a the `variables` key as additional metadata. The value of this key should be a list of variable names that are used by this tag.

For example if the tag uses two variables, then the metadata table should look something like this:

| Key       | Value                              |
| --------- | ---------------------------------- |
| variables | dlv - variable 1, dlv - variable 2 |

The variable values should always be kept up to date with the variable names and variables used in the Tag.

**Channel Info**

The `channel` key is used to attach channel information to variable errors. This is used to to calculate the impact of errors on a specific channel.

For example, if the tag is a "Facebook - Add to Cart" event pixel then the channel would look something like this:

| Key     | Value    |
| ------- | -------- |
| channel | facebook |

The channel should be one of these values:

`facebook`, `snapchat`, `twitter`, `pinterest`, `criteo`, `klaviyo`, `google analytics`, `google ads`, `floodlight`, `google optimize`.

> A custom value is also supported and it should be written in the same style. Some advanced channel specific functionality might be lost

---

Publish your container and you are ready to go!
