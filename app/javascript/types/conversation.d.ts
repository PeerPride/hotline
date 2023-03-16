import { IContactDetails } from './contact';
import { IConversationCategoryDetails } from './conversationcategory';
import { ITagGroup } from './taggroup';

export interface IConversation {
  id: number;
  attributes: IConversationCategory;
}

export interface IConversationDetails {
  id: number;
  method: string;
  notes: string;
  provider_id: string;
  length: number;
  started_at: string;
  ended_at: string;
  status: string;
  created_at: string;
  updated_at: string;
  started_at: string;
  contact_phone_id: number;
  conversation_category_id: number;
  contact: IContactDetails;
  conversation_category: IConversationCategoryDetails;
  tag_groups: ITagGroup[];
}
