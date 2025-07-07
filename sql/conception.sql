-- Active: 1751743068514@@127.0.0.1@3306@finance
CREATE TABLE Etablissement_Financier (
    id INT AUTO_INCREMENT,
    nom_etablissement VARCHAR(50) NOT NULL,
    fonds DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY(id)
);

CREATE TABLE Type_Pret (
    id INT AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    taux DECIMAL(5,2) NOT NULL CHECK (taux >= 0),
    duree_max INT NOT NULL CHECK (duree_max > 0),
    montant_min DECIMAL(15,2) CHECK (montant_min >= 0),
    montant_max DECIMAL(15,2) NOT NULL CHECK (montant_max > montant_min),
    min_age INT CHECK (min_age >= 0),
    max_age INT CHECK (max_age >= min_age),
    PRIMARY KEY(id)
);

CREATE TABLE Clients (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    motdepasse VARCHAR(255) NOT NULL, -- Pour stocker un hash sécurisé
    revenu_mensuel DECIMAL(10,2) CHECK (revenu_mensuel >= 0),
    date_naissance DATE,
    PRIMARY KEY(id)
);

CREATE TABLE Pret (
    id INT AUTO_INCREMENT,
    id_type_pret INT NOT NULL,
    id_client INT NOT NULL,
    montant_pret DECIMAL(15,2),
    mensualite DECIMAL(10,2),
    duree_mois INT,
    taux_interet_applique DECIMAL(5,2),
    date_debut DATE NOT NULL,
    montant_restant DECIMAL(15,2),
    PRIMARY KEY(id),
    FOREIGN KEY(id_type_pret) REFERENCES Type_Pret(id),
    FOREIGN KEY(id_client) REFERENCES Clients(id)
);

CREATE TABLE Statut_Pret (
    id INT AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Type_Transaction (
    id INT AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Compte (
    id INT AUTO_INCREMENT,
    id_client INT NOT NULL,
    solde_actuel DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY(id),
    FOREIGN KEY(id_client) REFERENCES Clients(id)
);

CREATE TABLE Type_Mouvement (
    id INT AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Mouvement_Argent (
    id INT AUTO_INCREMENT,
    id_compte INT NOT NULL,
    id_type_mouvement INT NOT NULL,
    montant DECIMAL(15,2) NOT NULL,
    date_paiement DATETIME NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_compte) REFERENCES Compte(id),
    FOREIGN KEY(id_type_mouvement) REFERENCES Type_Mouvement(id)
);

CREATE TABLE Transactions (
    id INT AUTO_INCREMENT,
    id_mouvement_argent INT NOT NULL,
    id_ef INT NOT NULL,
    id_type_transaction INT NOT NULL,
    date_transaction DATETIME NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_mouvement_argent) REFERENCES Mouvement_Argent(id),
    FOREIGN KEY(id_ef) REFERENCES Etablissement_Financier(id),
    FOREIGN KEY(id_type_transaction) REFERENCES Type_Transaction(id)
);

CREATE TABLE Historique_Statut_Pret (
    id INT AUTO_INCREMENT,
    id_pret INT NOT NULL,
    id_statut_pret INT NOT NULL,
    date_statut DATETIME NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_pret) REFERENCES Pret(id),
    FOREIGN KEY(id_statut_pret) REFERENCES Statut_Pret(id)
);
