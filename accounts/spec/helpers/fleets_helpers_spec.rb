# frozen_string_literal: true

require 'rails_helper'

describe FleetsHelper do
  let(:current_page) { 1 }
  let(:total_pages) { 13 }

  describe '.fleets_paginated_pages' do
    subject { helper.fleets_paginated_pages(current_page, total_pages) }

    context 'when there is no more than 13 pages in total' do
      it 'returns array of integers from 1 to 13' do
        expect(subject).to eq((1..13).to_a)
      end
    end

    context 'when there is more than 13 pages in total' do
      context 'when current_page is 1 or 2' do
        let(:current_page) { 2 }
        let(:total_pages) { 30 }

        it 'returns array of pages and elipsis' do
          expect(subject).to eq([1, 2, 3, 4, 5, 6, '...', 28, 29, 30])
        end
      end

      context 'when elipsis is hide in the first pages' do
        let(:current_page) { 8 }
        let(:total_pages) { 30 }

        it 'returns array of pages and one elipsis' do
          expect(subject).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, '...', 28, 29, 30])
        end
      end

      context 'when two elipsis are shown' do
        let(:current_page) { 15 }
        let(:total_pages) { 30 }

        it 'returns array of pages and two elipsis' do
          expect(subject).to eq([1, 2, 3, '...', 12, 13, 14, 15, 16, 17, 18, '...', 28, 29, 30])
        end
      end

      context 'when elipsis is hide in the first pages' do
        let(:current_page) { 23 }
        let(:total_pages) { 30 }

        it 'returns array of pages and one elipsis' do
          expect(subject).to eq([1, 2, 3, '...', 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30])
        end
      end

      context 'when current_page is within two last pages' do
        let(:current_page) { 29 }
        let(:total_pages) { 30 }

        it 'returns array of pages and elipsis' do
          expect(subject).to eq([1, 2, 3, '...', 25, 26, 27, 28, 29, 30])
        end
      end
    end
  end
end
