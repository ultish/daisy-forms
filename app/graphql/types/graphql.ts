/* eslint-disable */
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = {
  [K in keyof T]: T[K];
};
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>;
};
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>;
};
export type MakeEmpty<
  T extends { [key: string]: unknown },
  K extends keyof T,
> = { [_ in K]?: never };
export type Incremental<T> =
  | T
  | {
      [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never;
    };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string };
  String: { input: string; output: string };
  Boolean: { input: boolean; output: boolean };
  Int: { input: number; output: number };
  Float: { input: number; output: number };
  _Any: { input: any; output: any };
  _FieldSet: { input: any; output: any };
};

export type Mutation = {
  __typename?: 'Mutation';
  updatePerson: Person;
};

export type MutationUpdatePersonArgs = {
  id: Scalars['ID']['input'];
  personName?: InputMaybe<Scalars['String']['input']>;
  petId?: InputMaybe<Scalars['ID']['input']>;
  petName?: InputMaybe<Scalars['String']['input']>;
};

export type Person = {
  __typename?: 'Person';
  age: Scalars['Int']['output'];
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  pets: Array<Pet>;
};

export type Pet = {
  __typename?: 'Pet';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  species: Scalars['String']['output'];
  toys: Array<Toy>;
};

export type Query = {
  __typename?: 'Query';
  _service: _Service;
  people: Array<Person>;
  person: Person;
};

export type QueryPersonArgs = {
  id: Scalars['ID']['input'];
};

export type Subscription = {
  __typename?: 'Subscription';
  countdown: Scalars['Int']['output'];
  personUpdated: Person;
};

export type SubscriptionCountdownArgs = {
  from: Scalars['Int']['input'];
};

export type SubscriptionPersonUpdatedArgs = {
  id: Scalars['ID']['input'];
};

export type Toy = {
  __typename?: 'Toy';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  type: Scalars['String']['output'];
};

export type _Service = {
  __typename?: '_Service';
  sdl?: Maybe<Scalars['String']['output']>;
};
