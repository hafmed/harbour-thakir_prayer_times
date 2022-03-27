/*
 * DownloadManager.cpp
 *
 *  Created on: Fev 19, 2022
 *      Author: haf-perso
 */

#include "DownloadManager.hpp"
#include <QtCore/QFileInfo>
#include <QtCore/QTimer>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QDir>
#include <QDebug>
#include <QFile>

DownloadManager::DownloadManager()
    : QObject(), m_currentDownload(0), m_downloadedCount(0), m_totalCount(0), m_progressTotal(0), m_progressValue(0)
{
    QDir(QDir::currentPath() + "/Downloads/").mkdir("Temp_Quran");

}
DownloadManager::~DownloadManager() {
}

QString DownloadManager::errorMessage() const
{
    return m_errorMessage.join("\n");
}

QString DownloadManager::statusMessage() const
{
    return m_statusMessage.join("\n");
}

int DownloadManager::activeDownloads() const
{
    return m_downloadQueue.count();
}

int DownloadManager::progressTotal() const
{
    return m_progressTotal;
}

int DownloadManager::progressValue() const
{
    return m_progressValue;
}

QString DownloadManager::progressMessage()
{
    QString temp="m_progressMessage";
    return m_progressMessage;
}

void DownloadManager::downloadUrl(const QString &url )
{
    append(QUrl(url));
}

void DownloadManager::append(const QUrl &url)
{
    /**
       * If there is no job in the queue at the moment or we do
       * not process any job currently, then we trigger the processing
       * of the next job.
       */
    if (m_downloadQueue.isEmpty() && !m_currentDownload)
        QTimer::singleShot(0, this, SLOT(startNextDownload()));

    // Enqueue the new URL to the job queue
    m_downloadQueue.enqueue(url);
    emit activeDownloadsChanged();

    // Increment the total number of jobs
    ++m_totalCount;
}

QString DownloadManager::saveFileName(const QUrl &url )
{

    // First extract the path component from the URL ...
    const QString path = url.path();
    pathHAF=path;
    //qDebug() << "url --> " << path;

    // ... and then extract the file name.

    int lenghtpath=path.length()-17;
    //qDebug() << path.mid(6,lenghtpath);
    nameKria= path.mid(6,lenghtpath);
    QString basename = QFileInfo(path).fileName();

    if (basename.isEmpty())
        basename = "Downloads";

    basename = "Downloads/Temp_Quran/" + basename;

    return basename;
}

void DownloadManager::addErrorMessage(const QString &message)
{
    // HAF
    m_errorMessage.clear();
    //
    m_errorMessage.append(message);
    emit errorMessageChanged();
}

void DownloadManager::addStatusMessage(const QString &message)
{
    // HAF
    m_statusMessage.clear();
    //
    m_statusMessage.append(message);
    emit statusMessageChanged();
}

void DownloadManager::startNextDownload()
{
    // If the queue is empty just add a new status message
    if (m_downloadQueue.isEmpty()) {
        //addStatusMessage(QString("%1/%2 files downloaded successfully").arg(m_downloadedCount).arg(m_totalCount));
        addStatusMessage(tr("Files downloaded successfully: %1 of %2").arg(m_downloadedCount).arg(m_totalCount));
        return;
    }

    // Otherwise dequeue the first job from the queue ...
    const QUrl url = m_downloadQueue.dequeue();

    // ... and determine a local file name where the result can be stored.
    const QString filename = saveFileName(url);

    // Open the file with this file name for writing
    m_output.setFileName(filename);
    if (!m_output.open(QIODevice::WriteOnly)) {
        addErrorMessage(QString(tr("Problem opening save file '%1' for download '%2': %3")).arg(filename, url.toString(), m_output.errorString()));

        startNextDownload();
        return; // skip this download
    }

    // Now create the network request for the URL ...
    QNetworkRequest request(url);

    // ... and start the download.
    m_currentDownload = m_manager.get(request);

    // Connect against the necessary signals to get informed about progress and status changes
    connect(m_currentDownload, SIGNAL(downloadProgress(qint64, qint64)),
            SLOT(downloadProgress(qint64, qint64)));
    connect(m_currentDownload, SIGNAL(finished()), SLOT(downloadFinished()));
    connect(m_currentDownload, SIGNAL(readyRead()), SLOT(downloadReadyRead()));

    // Add a status message
    //      addStatusMessage(QString("Downloading %1...").arg(url.toString()));
    addStatusMessage(tr("Loading ...\n %1").arg(url.toString()));

    // Start the timer so that we can calculate the download speed later on
    m_downloadTime.start();

}

void DownloadManager::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    // Update the properties with the new progress values
    m_progressTotal = bytesTotal;
    m_progressValue = bytesReceived;
    emit progressTotalChanged();
    emit progressValueChanged();

    // Calculate the download speed ...
    double speed = bytesReceived * 1000.0 / m_downloadTime.elapsed();
    QString unit;
    if (speed < 1024) {
        unit = "bytes/sec";
    } else if (speed < 1024 * 1024) {
        speed /= 1024;
        unit = "kB/s";
    } else {
        speed /= 1024 * 1024;
        unit = "MB/s";
    }

    // ... and update the progress message.
    m_progressMessage = QString("%1 %2").arg(speed, 3, 'f', 1).arg(unit);
    emit progressMessageChanged();
}

void DownloadManager::downloadFinished()
{
    // Reset the progress information when the download has finished
    m_progressTotal = 0;
    m_progressValue = 0;
    m_progressMessage.clear();
    emit progressValueChanged();
    emit progressTotalChanged();
    emit progressMessageChanged();

    // Close the file where the data have been written
    m_output.close();

    // Add a status or error message
    if (m_currentDownload->error()) {
        //addErrorMessage(QString("Failed: %1").arg(m_currentDownload->errorString()));
        addErrorMessage(tr("Failed: %1").arg(m_currentDownload->errorString()));
    } else {
        //addStatusMessage("Succeeded.");
        addErrorMessage(tr("nothing"));

        addStatusMessage(tr("Achieved."));


        QString Name_mp3=QFileInfo(pathHAF).fileName();
        QString from = QDir::currentPath() + "/Downloads/Temp_Quran/"+Name_mp3;
        QDir(QDir::currentPath() + "/Downloads/").mkdir("Thakir_Quran");

        QDir(QDir::currentPath() + "/Downloads/Thakir_Quran/").mkdir(nameKria);
        QString to = QDir::currentPath() + "/Downloads/Thakir_Quran/"+nameKria+"/"+Name_mp3;
        QFile::copy(from, to);

        QFile::remove(QDir::currentPath() + "/Downloads/Temp_Quran/"+Name_mp3);

        ++m_downloadedCount;
    }

    /**
           * We can't call 'delete m_currentDownload' here, because this method might have been invoked directly as result of a signal
           * emission of the network reply object.
           */
    m_currentDownload->deleteLater();
    m_currentDownload = 0;
    emit activeDownloadsChanged();

    // Trigger the execution of the next job
    startNextDownload();
}

void DownloadManager::downloadReadyRead()
{
    // Whenever new data are available on the network reply, write them out to the result file
    m_output.write(m_currentDownload->readAll());
}

//HAF 23-01-2015
void DownloadManager::downloadStop()
{
    m_currentDownload->close();
}
void DownloadManager::m_totalCountZero()
{
    m_totalCount=0; //HAF 19-2-2022
    m_downloadedCount=0;
}
