module TagManager
  extend ActiveSupport::Concern

  def edit_tags(project, tags)
    before = project.tags.pluck(:name)
    after = split_tags(tags)
    add_tags(project, after.difference(before))
    remove_tags(project, before.difference(after))
  end

  def delete_all_tags(project)
    remove_tags(project, project.tags.pluck(:name))
  end

  private

    def split_tags(tags)
      tag_list = tags.split(",").map(&:strip)
      tag_list.uniq
    end

    def add_tags(project, tag_list)
      return false if tag_list.blank?
      tag_list.each do |item|
        tag = Tag.find_by(name: item) || Tag.create(name: item)
        Tagging.create(project_id: project.id, tag_id: tag.id)
      end
    end

    def remove_tags(project, tag_list)
      return false if tag_list.blank?
      tag_list.each do |item|
        tag = Tag.find_by(name: item)
        Tagging.find_by(project_id: project.id, tag_id: tag.id).destroy
        if tag.projects.count.zero?
          tag.destroy
        end
      end
    end
end
