export interface IContact {
  id: number;
  attributes: IContactDetails;
}

export interface IContactDetails {
  id: number;
  codename: string;
  notes: string;
  blocked: boolean;
}
