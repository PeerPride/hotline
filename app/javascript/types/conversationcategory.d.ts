export interface IConversationCategory {
  id: number;
  attributes: IConversationCategoryDetails;
}

export interface IConversationCategoryDetails {
  id: number;
  name: string;
  is_active: boolean;
  description: string;
  item_order: number;
}
