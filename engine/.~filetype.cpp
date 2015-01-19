/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2014  smith AR <audoban@openmailbox.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "filetype.h"
#include <KMimeType>
#include <QFile>
#include <QLatin1String>
#include <QDebug>

#include <audioproperties.h>
#include <flacfile.h>
#include <mpcfile.h>
#include <mpegfile.h>
#include <oggfile.h>
#include <oggflacfile.h>
#include <vorbisfile.h>

#include <taglib_config.h>
#ifdef TAGLIB_WITH_MP4
#include <mp4file.h>
#endif

namespace MediaFiles
{
static const QLatin1String flacType("audio/flac");
static const QLatin1String mp3Type("audio/mpeg");
#ifdef TAGLIB_WITH_MP4
static const QLatin1String mp4Type("audio/mp4");
#endif
static const QLatin1String mpcType("audio/x-musepack");
static const QLatin1String oggType("audio/ogg");
static const QLatin1String oggFlacType("audio/x-flac+ogg");
static const QLatin1String oggVorbisType("audio/x-vorbis+ogg");
static const QLatin1String vorbisType("audio/vorbis");
}

File* FileType::createFile(const QString& fileName)
{
    QUrl url(fileName);
    if(!url.isLocalFile()) return 0;

    KMimeType::Ptr mime = KMimeType::findByUrl(url.toLocalFile());
    if (!mime->isValid()) return 0;

    File* file(0);
    QByteArray encodedFileName(QFile::encodeName(url.toLocalFile()));

    if (mime->is(MediaFiles::flacType))
        file = new FLAC::File(encodedFileName.constData());
    else if (mime->is(MediaFiles::mp3Type))
        file = new MPEG::File(encodedFileName.constData());
    else if (mime->is(MediaFiles::mpcType))
        file = new MPC::File(encodedFileName.constData());
    else if (mime->is(MediaFiles::oggFlacType) ||
        mime->is(MediaFiles::vorbisType))
        file = new Ogg::FLAC::File(encodedFileName.constData(), AudioProperties::Accurate);
    else if (mime->is(MediaFiles::oggVorbisType))
        file = new Ogg::Vorbis::File(encodedFileName.constData(), true, AudioProperties::Accurate);
#ifdef TAGLIB_WITH_MP4
    else if (mime->is(MediaFiles::mp4Type))
        file = new MP4::File(encodedFileName.constData());
#endif

    if( !file )
        qDebug() << QString( "FileTypeResolver: file %1 (mimetype %2) not" "recognized as compatible" ).arg(fileName,
mime->name()).toLocal8Bit().data();

    if(file && !file->isValid()){
        delete file;
        file = 0;
    }
    return file;

}
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
