import { IConversation } from './conversation';

export interface ITagGroup {
  id: number;
  conversation: IConversation;
  tags: ITagDetails[];
}
