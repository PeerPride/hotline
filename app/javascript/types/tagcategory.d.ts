export interface ITagCategory {
  id: number;
  attributes: ITagCategoryDetails;
}

export interface ITagCategoryDetails {
  id: number;
  name: string;
  description: string;
  is_active: boolean;
  item_order: number;
  tags: ITagDetails[];
}
