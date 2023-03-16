export interface ITag {
  id: number;
  attributes: ITagDetails;
}

export interface ITagDetails {
  id: number;
  name: string;
  description: string;
  is_active: boolean;
  item_order: number;
  tag_category_id: number;
}
