interface IsLoaded {
  isLoaded: boolean;
  config: Config;
}

type StateToggle = {
  open: boolean;
  setOpen: (open: boolean) => void;
};

interface StateConfig {
  config: Config;
  setConfig: (config: Config) => void;
  getLocale: (key: string) => string;
}

type Config = {
  maxCharacters: number;
  colors: {
    [key: string]: string;
  };
  locale: any;
  nationalities: string[];
};

interface StateCharacters {
  characters: Characters;
  setCharacters: (characters: Characters) => void;
}

type Characters = {
  [cid: string]: Character;
};

interface Character {
  cid: number;
  citizenid: string;
  charinfo: {
    firstname: string;
    lastname: string;
    gender: number;
    birthdate: string;
    nationality: string;
  };
  money: {
    cash: number;
    bank: number;
  };
  job: {
    name: string;
    label: string;
    grade: {
      name: string;
    };
  };
  gang: {
    name: string;
    label: string;
    grade: {
      name: string;
    };
  };
}
