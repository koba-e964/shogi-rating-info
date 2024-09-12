CREATE TABLE scraped_info(
    page_hash VARCHAR(100) NOT NULL,
    scraped_date timestamp NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY (page_hash)
);

CREATE TABLE player_info(
    id INT,
    kind VARCHAR(10),
    mentor_id INT NOT NULL,
    page_hash VARCHAR(100), -- ページのハッシュ。
    PRIMARY KEY (kind, id),
    CONSTRAINT kind_constraint CHECK (kind in ('lady', 'pro')),
    FOREIGN KEY (page_hash) REFERENCES scraped_info(page_hash)
);
CREATE INDEX player_info_index ON player_info(mentor_id, id);
CREATE INDEX player_info_id_index ON player_info(id);
