module MetaTags
  # Contains methods to use in controllers.
  #
  # You can define several instance variables to set meta tags:
  #   @page_title = 'Member Login'
  #   @page_description = 'Member login page.'
  #   @page_keywords = 'Site, Login, Members'
  #
  # Also you can use {#set_meta_tags} method, that have the same parameters
  # as {ViewHelper#set_meta_tags}.
  #
  module ControllerHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :render, :meta_tags
      before_filter :render_meta_tags_from_locale
    end

    # Processes the <tt>@page_title</tt>, <tt>@page_keywords</tt>, and
    # <tt>@page_description</tt> instance variables and calls +render+.
    def render_with_meta_tags(*args, &block)
      self.meta_tags[:title]       = @page_title       if @page_title
      self.meta_tags[:keywords]    = @page_keywords    if @page_keywords
      self.meta_tags[:description] = @page_description if @page_description

      render_without_meta_tags(*args, &block)
    end
    protected :render_with_meta_tags

    # Set meta tags for the page.
    #
    # See <tt>MetaTags::ViewHelper#set_meta_tags</tt> for details.
    def set_meta_tags(meta_tags)
      self.meta_tags.update(meta_tags)
    end
    protected :set_meta_tags

    # Get meta tags for the page.
    def meta_tags
      @meta_tags ||= MetaTagsCollection.new
    end
    protected :meta_tags

    def render_meta_tags_from_locale
      name_space = "meta_tags.#{controller_name}.#{action_name}"
      self.meta_tags[:title]       = I18n.t("#{name_space}.title") unless I18n.t("#{name_space}.title", default: "").blank?
      self.meta_tags[:keywords]    = I18n.t("#{name_space}.keywords") unless I18n.t("#{name_space}.keywords", default: "").blank?
      self.meta_tags[:description] = I18n.t("#{name_space}.description") unless I18n.t("#{name_space}.description", default: "").blank?
    end
    protected :render_meta_tags_from_locale
  end
end
