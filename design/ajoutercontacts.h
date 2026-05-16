#ifndef AJOUTERCONTACTS_H
#define AJOUTERCONTACTS_H

#include <QDialog>

namespace Ui {
class AjouterContacts;
}

class AjouterContacts : public QDialog
{
    Q_OBJECT

public:
    explicit AjouterContacts(QWidget *parent = nullptr);
    ~AjouterContacts();

private:
    Ui::AjouterContacts *ui;
};

#endif // AJOUTERCONTACTS_H
