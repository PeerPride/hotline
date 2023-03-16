import { ILanguageDetails } from './language';

export interface IUser {
  id: number;
  attributes: IUserDetails;
}

export interface IUserDetails {
  id: number;
  name: string;
  last_sign_in_at: string;
  phone_number: string;
  email: string;
  on_call_name: string;
  pronouns: string;
  bio: Text;
  languages: ILanguageDetails[];
}
