package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.AdministratorInvitation;
import com.studymate.model.entity.EmailVerificationToken;
import com.studymate.model.entity.PasswordResetToken;
import org.hibernate.query.Query;

import java.util.Optional;

public class TokenDao {

    public Optional<EmailVerificationToken> findVerificationTokenByHash(String tokenHash) {
        return HibernateUtil.executeWithResult(session -> {
            Query<EmailVerificationToken> q = session.createQuery(
                    "SELECT t FROM EmailVerificationToken t JOIN FETCH t.user WHERE t.tokenHash = :h",
                    EmailVerificationToken.class
            );
            q.setParameter("h", tokenHash);
            return q.uniqueResultOptional();
        });
    }

    public void saveVerificationToken(EmailVerificationToken token) {
        HibernateUtil.executeInTransaction(session -> session.persist(token));
    }

    public void updateVerificationToken(EmailVerificationToken token) {
        HibernateUtil.executeInTransaction(session -> session.merge(token));
    }

    public Optional<PasswordResetToken> findResetTokenByHash(String tokenHash) {
        return HibernateUtil.executeWithResult(session -> {
            Query<PasswordResetToken> q = session.createQuery(
                    "SELECT t FROM PasswordResetToken t JOIN FETCH t.user WHERE t.tokenHash = :h",
                    PasswordResetToken.class
            );
            q.setParameter("h", tokenHash);
            return q.uniqueResultOptional();
        });
    }

    public void saveResetToken(PasswordResetToken token) {
        HibernateUtil.executeInTransaction(session -> session.persist(token));
    }

    public void updateResetToken(PasswordResetToken token) {
        HibernateUtil.executeInTransaction(session -> session.merge(token));
    }

    public Optional<AdministratorInvitation> findInvitationByHash(String tokenHash) {
        return HibernateUtil.executeWithResult(session -> {
            Query<AdministratorInvitation> q = session.createQuery(
                    "SELECT i FROM AdministratorInvitation i JOIN FETCH i.invitedBy WHERE i.tokenHash = :h",
                    AdministratorInvitation.class
            );
            q.setParameter("h", tokenHash);
            return q.uniqueResultOptional();
        });
    }

    public Optional<AdministratorInvitation> findInvitationByEmail(String email) {
        return HibernateUtil.executeWithResult(session -> {
            Query<AdministratorInvitation> q = session.createQuery(
                    "FROM AdministratorInvitation i WHERE LOWER(i.email) = LOWER(:email) AND i.accepted = false",
                    AdministratorInvitation.class
            );
            q.setParameter("email", email.trim());
            return q.uniqueResultOptional();
        });
    }

    public void saveInvitation(AdministratorInvitation invitation) {
        HibernateUtil.executeInTransaction(session -> session.persist(invitation));
    }

    public void updateInvitation(AdministratorInvitation invitation) {
        HibernateUtil.executeInTransaction(session -> session.merge(invitation));
    }
}

