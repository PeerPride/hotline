export interface ILanguage {
  id: number;
  attributes: ILanguageDetails;
}

export interface ILanguageDetails {
  id: number;
  name: string;
  is_active: boolean;
}
