export interface ILine {
  id: number;
  attributes: ILineDetails;
}

export interface ILineDetails {
  id: number;
  name: string;
  number: string;
  is_active: boolean;
  phone_greeting_message: string;
  greeting_audio: string;
  record_calls: boolean | string;
  recording_save_length: number;
  accepts_phone_calls: boolean;
  accepts_text_messages: boolean;
  accepts_voicemails: boolean;
  no_operators_phone_message: string;
  no_operators_text_message: string;
  voicemail_greeting: string;
}
