CREATE TABLE scraped_pages(
    page_hash VARCHAR(100) NOT NULL UNIQUE,
    url VARCHAR(100) NOT NULL,
    status_code INT NOT NULL,
    scraped_date timestamp NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY (page_hash)
);
CREATE INDEX scraped_pages_url_history ON scraped_pages(url, scraped_date);

CREATE TABLE players(
    kind VARCHAR(5) NOT NULL,
    id INT NOT NULL,
    name_jp VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    title VARCHAR(10) NOT NULL, -- 称号。竜王、七段、女流王将など
    mentor_name VARCHAR(100) NOT NULL, -- 師匠の名前
    birthday DATE NOT NULL,
    page_hash VARCHAR(100) NOT NULL, -- ページのハッシュ。
    PRIMARY KEY (kind, id),
    CONSTRAINT kind_constraint CHECK (kind in ('lady', 'pro')),
    FOREIGN KEY (page_hash) REFERENCES scraped_pages(page_hash)
);
CREATE INDEX players_id_index ON players(id);
CREATE INDEX players_name_jp_index ON players(name_jp); -- 名寄せのため

CREATE TABLE players_mentorship(
    mentee_kind VARCHAR(5) NOT NULL,
    mentee_id INT NOT NULL,
    mentor_kind VARCHAR(5) NOT NULL,
    mentor_id INT NOT NULL,
    PRIMARY KEY (mentee_kind, mentee_id),
    FOREIGN KEY (mentor_kind, mentor_id) REFERENCES players(kind, id),
    FOREIGN KEY (mentee_kind, mentee_id) REFERENCES players(kind, id)
);
CREATE INDEX players_mentorship_mentor_index ON players_mentorship(mentor_id, mentee_id);


CREATE TABLE games(
    id SERIAL NOT NULL,
    kind_black VARCHAR(5) NOT NULL,
    player_id_black INT NOT NULL,
    kind_white VARCHAR(5) NOT NULL,
    player_id_white INT NOT NULL,
    game_date DATE NOT NULL,
    game_result VARCHAR(10) NOT NULL,
    page_hash VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (kind_black, player_id_black) REFERENCES players(kind, id),
    FOREIGN KEY (kind_white, player_id_white) REFERENCES players(kind, id),
    FOREIGN KEY (page_hash) REFERENCES scraped_pages(page_hash),
    CONSTRAINT game_result_constraint CHECK (game_result in ('black', 'white', 'sen', 'jishogi'))
);
CREATE INDEX games_date_index ON games(game_date);

CREATE TABLE tournaments(
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    page_hash VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (page_hash) REFERENCES scraped_pages(page_hash)
);

CREATE TABLE tournament_components(
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    rule VARCHAR(10) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT rule_constraint CHECK (rule in ('round-robin', 'elimination'))
);

CREATE TABLE tournament_components_games(
    id SERIAL NOT NULL,
    tournament_id INT NOT NULL,
    component_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tournament_id) REFERENCES tournaments(id),
    FOREIGN KEY (component_id) REFERENCES tournament_components(id)
);
