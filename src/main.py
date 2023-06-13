'''driver'''
from time import perf_counter, gmtime, strftime

from boto3 import client

from libs.cli import parse_args
from libs.logger import logger
from libs.s3_md5 import parse_file_md5

if __name__ == '__main__':
    start_time = perf_counter()
    args = parse_args()
    main_s3_client = client('s3')
    md5_hash = parse_file_md5(
        main_s3_client,
        args.bucket,
        args.file_name,
        args.chunk_size,
        args.workers
    )
    elapsed_time = perf_counter() - start_time
    logger.infof(f"chunk size {args.chunk_size/(1024 * 1024)}")
    logger.info(f"md5 hash {md5_hash} for {args.file_name}")
    logger.info(f"took {strftime('%H:%M:%S', gmtime(elapsed_time))}")
