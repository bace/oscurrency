module GroupsHelper
  
  def group_owner?(person,group)
    person == group.owner
  end
  
  # Return a group's image link.
  # The default is to display the group's icon linked to the profile.
  def group_image_link(group, options = {})
    link = options[:link] || group
    image = options[:image] || :icon
    unless options[:image_options].nil?
      title_prefix = options[:image_options][:class] == 'default-group-link' ? t('return_to') : ''
    end
    group_title = (title_prefix || '') + h(group.name)
    image_options = { :title => group_title, :alt => group_title }
    unless options[:image_options].nil?
      image_options.merge!(options[:image_options]) 
    end
    link_options =  { :title => h(group.name) }
    unless options[:link_options].nil?                    
      link_options.merge!(options[:link_options])
    end
    content = image_tag(group.send(image), image_options) unless group.send(image).blank?
    # This is a hack needed for the way the designer handled rastered images
    # (with a 'vcard' class).
    if options[:vcard]
      content = %(#{content}#{content_tag(:span, h(group.name), 
                                                 :class => "fn" )})
    end
    link_to(content, link, link_options)
  end
  
  def group_link(group)
    link_to(h(group.name), group_path(group))
  end

  def delete_membership_link(person,group)
    membership = Membership.mem(person,group)
    if membership
      membership_path(membership)
    else
      "#"
    end
  end

  def reqs_options
    options_for_select([[t('reqs.index.active_requests'),1],[t('filter_categories'),2],[t('filter_neighborhoods'),3]])
  end

  def offers_options
    options_for_select([[t('offers.index.active_offers'),1],[t('filter_categories'),2],[t('filter_neighborhoods'),3]])
  end

  def memberships_options
    options_for_select([[t('all_members'),1],[t('filter_categories'),2],[t('filter_neighborhoods'),3]])
  end
end
