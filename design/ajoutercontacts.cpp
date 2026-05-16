#include "ajoutercontacts.h"
#include "ui_ajoutercontacts.h"

AjouterContacts::AjouterContacts(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::AjouterContacts)
{
    ui->setupUi(this);
}

AjouterContacts::~AjouterContacts()
{
    delete ui;
}
