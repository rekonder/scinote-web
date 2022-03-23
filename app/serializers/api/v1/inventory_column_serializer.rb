# frozen_string_literal: true

module Api
  module V1
    class InventoryColumnSerializer < ActiveModel::Serializer
      type :inventory_columns
      attributes :name, :data_type, :metadata
      attribute :repository_stock_unit_items,  if: (lambda do
                                                      object.data_type == 'RepositoryStockValue'
                                                    end)

      has_many :repository_list_items,
               key: :inventory_list_items,
               serializer: InventoryListItemSerializer,
               class_name: 'RepositoryListItem',
               if: (lambda do
                 object.data_type == 'RepositoryListValue' &&
                   !instance_options[:hide_list_items]
               end)
      has_many :repository_checklist_items,
               key: :inventory_checklist_items,
               serializer: InventoryChecklistItemSerializer,
               class_name: 'RepositoryChecklistItem',
               if: (lambda do
                 object.data_type == 'RepositoryChecklistValue' &&
                  !instance_options[:hide_list_items]
               end)
      has_many :repository_status_items,
               key: :repository_status_items,
               serializer: InventoryStatusItemSerializer,
               class_name: 'RepositoryStatusItem',
               if: (lambda do
                 object.data_type == 'RepositoryStatusValue' &&
                   !instance_options[:hide_list_items]
               end)

      include TimestampableModel

      def data_type
        Extends::API_REPOSITORY_DATA_TYPE_MAPPINGS[object.data_type]
      end

      def repository_stock_unit_items
        self.object.repository_stock_unit_items.map do |item|
          {
            id: item.id,
            data: item.data,
            created_at: item.created_at,
            updated_at: item.updated_at
          }
        end
      end
    end
  end
end
