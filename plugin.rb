# frozen_string_literal: true

# name: discourse-private-template-tagger
# about: Tag private templates when users are unable to
# version: 1.0
# authors: Communiteq
# url: https://github.com/communiteq/discourse-private-template-tagger

# This plugin is not needed once we're on 3.5 since the automation plugin will allow us to do this

enabled_site_setting :private_template_tagger_enabled

after_initialize do
  on(:topic_created) do |topic|
    if SiteSetting.private_template_tagger_enabled && topic.private_message?
      user = topic.user
      target_usernames = topic.allowed_users.pluck(:username) - [user.username]
      if target_usernames.include?(SiteSetting.private_template_tagger_username)
        guardian = Guardian.new(Discourse.system_user)
        tags = [ SiteSetting.private_template_tagger_tag ]
        DiscourseTagging.tag_topic_by_names(topic, guardian, tags, append: true)
      end
    end
  end
end
