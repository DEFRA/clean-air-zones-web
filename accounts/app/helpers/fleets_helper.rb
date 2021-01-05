# frozen_string_literal: true

# View helpers for manage vehicles flow
module FleetsHelper
  # returns true if selected confirm_fleet_check in session equals provided value
  # method used in VehiclesManagement::Fleet Check step during Sign up
  def checked_fleet_checked?(value)
    new_account_data[:confirm_fleet_check].to_s == value
  end

  # Returns pages to fleets management pagination
  def fleets_paginated_pages(current_page, total_pages)
    return (1..total_pages).to_a unless total_pages > 13

    paginated_pages(current_page, total_pages)
  end

  private

  # Return first pages for fleet pagination
  def pages_head(current_page)
    head = [1, 2, 3]
    head += [4, 5, 6] if current_page <= 2
    head
  end

  # Return last pages for fleet pagination
  def pages_tail(current_page, total_pages)
    tail = [total_pages - 2, total_pages - 1, total_pages]
    tail += [total_pages - 5, total_pages - 4, total_pages - 3] if current_page >= total_pages - 1
    tail
  end

  # Returns center range of pages for fleet pagination
  def pages_body(current_page)
    (current_page - 3..current_page + 3).to_a
  end

  # Prepare pages to paginate
  def prepare_pages(current_page, total_pages)
    pages = pages_head(current_page) + pages_body(current_page) + pages_tail(current_page, total_pages)

    pages.uniq.sort.select { |num| num.positive? && num <= total_pages }
  end

  # Build pages for fleet pagination
  def paginated_pages(current_page, total_pages) # rubocop:disable Metrics/MethodLength
    paginated_pages = []
    pages = prepare_pages(current_page, total_pages)
    pages.each_with_index do |page, index|
      if (pages.size == index + 1) || (pages[index + 1] - page == 1)
        paginated_pages << page
      elsif pages[index + 1] - page == 2
        paginated_pages += [page, page + 1]
      else
        paginated_pages += [page, '...']
      end
    end

    paginated_pages
  end
end
